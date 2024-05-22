//
//  BDManager.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import Foundation
import CoreData
import UIKit

class DBManager: NSObject {
    
    // -> Singleton instance
    static let shared: DBManager = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer
        return DBManager(context: container.viewContext)
    }()
    
    var managedContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
        super.init()
    }
    
    func saveData() -> Bool {
        do {
            try managedContext.save()
            print("data saved!")
            return true
        } catch {
            print("Failed to save context: \(error)")
            print("data UNsaved!")
            return false
        }
    }
    
    // for registration page, save username and password
    func addUser(user: UserModel) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
            print("Failed to create entity description for User")
            return false
        }
        
        let newUser = NSManagedObject(entity: entity, insertInto: managedContext)
        newUser.setValue(user.username, forKey: "username")
        newUser.setValue(user.password, forKey: "password")
        newUser.setValue(user.isAdmin, forKey: "isAdmin")
        
        return saveData()
    }
    
    // for login page, to check if the user's info is in the coredata
    func loginUser(username: String, password: String) -> (success: Bool, user: User?) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        // match both username and password
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            
            // check if we found the user or not
            if let user = users.first {
                print("Authenticated user: \(user.username ?? "")")
                return (true, user)
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
        return (false, nil)
    }


  
}