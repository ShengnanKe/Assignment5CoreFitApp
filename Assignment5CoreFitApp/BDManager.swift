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
    var managedContext: NSManagedObjectContext!
    
    static let shared: DBManager = {
        let instance = DBManager()
        return instance
    }()
    
    private override init() {
        super.init()
        let application = UIApplication.shared
        let appDelegate = application.delegate as? AppDelegate
        let container = appDelegate?.persistentContainer
        self.managedContext = container?.viewContext
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
    
    func addExercise(exercise: ExerciseModel) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "ExerciseLibrary", in: managedContext) else {
            print("Failed to create entity description for ExerciseLibrary")
            return false
        }
        
        let newExercise = NSManagedObject(entity: entity, insertInto: managedContext)
        newExercise.setValue(exercise.exerciseName, forKey: "exerciseName")
        newExercise.setValue(exercise.exerciseDescription, forKey: "exerciseDescription")
        newExercise.setValue(exercise.mediaPath, forKey: "mediaPath")
        newExercise.setValue(exercise.muscleGroup, forKey: "muscleGroup")
        newExercise.setValue(exercise.ownerUsername, forKey: "ownerUsername")
        
        return saveData()
    }

}
