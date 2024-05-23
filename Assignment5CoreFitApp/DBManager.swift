//
//  DBManager.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
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
    
    func addExercise(exercise: ExerciseModel, user: User) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "ExerciseLibrary", in: managedContext) else {
            print("Failed to create entity description for ExerciseLibrary")
            return false
        }
        
        let newExercise = NSManagedObject(entity: entity, insertInto: managedContext) as! ExerciseLibrary
        newExercise.setValue(exercise.exerciseName, forKey: "exerciseName")
        newExercise.setValue(exercise.exerciseDescription, forKey: "exerciseDescription")
        newExercise.setValue(exercise.mediaPath, forKey: "mediaPath")
        newExercise.setValue(exercise.muscleGroup, forKey: "muscleGroup")
      
        user.addToCreatedExercises(newExercise)
        
        return saveData()
    }
    
    func deleteExercise(exercise: ExerciseLibrary) -> Bool {
        managedContext.delete(exercise)
        do {
            try managedContext.save()
            print("Exercise successfully deleted.")
            return true
        } catch let error as NSError {
            print("Error while deleting exercise: \(error), \(error.userInfo)")
            return false
        }
    }
    
    func addWorkoutPlan(workoutPlan: WorkoutPlanModel, user: User, exercises: [ExerciseLibrary]) -> Bool{
        guard let entity = NSEntityDescription.entity(forEntityName: "WorkoutPlan", in: managedContext) else {
            print("Failed to create entity description for WorkoutPlan")
            return false
        }
        
        let newWorkoutPlan = NSManagedObject(entity: entity, insertInto: managedContext) as! WorkoutPlan
        newWorkoutPlan.setValue(workoutPlan.name, forKey: "name")
        
        user.addToHasWorkoutPlans(newWorkoutPlan)
        
        for exercise in exercises {
            newWorkoutPlan.addToHasExercises(exercise)
        }
        
        return saveData()
    }
    
    func preloadAdminExercises() -> [NSManagedObject]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ExerciseLibrary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "createdByUser.isAdmin == %@", NSNumber(value: true))
        
        do {
            var adminExercises = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            return adminExercises
        } catch {
            print("Failed to fetch admin exercises: \(error)")
        }
        return nil
    }
    
    func deleteWorkoutPlan(workoutPlan: WorkoutPlan) -> Bool {
        managedContext.delete(workoutPlan)
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Error deleting workout plan: \(error), \(error.userInfo)")
            return false
        }
    }
    
}
