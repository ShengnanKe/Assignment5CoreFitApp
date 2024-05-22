//
//  User+CoreDataProperties.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var isAdmin: Bool
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var createdExercises: NSSet?
    @NSManaged public var hasWorkoutPlans: NSSet?

}

// MARK: Generated accessors for createdExercises
extension User {

    @objc(addCreatedExercisesObject:)
    @NSManaged public func addToCreatedExercises(_ value: ExerciseLibrary)

    @objc(removeCreatedExercisesObject:)
    @NSManaged public func removeFromCreatedExercises(_ value: ExerciseLibrary)

    @objc(addCreatedExercises:)
    @NSManaged public func addToCreatedExercises(_ values: NSSet)

    @objc(removeCreatedExercises:)
    @NSManaged public func removeFromCreatedExercises(_ values: NSSet)

}

// MARK: Generated accessors for hasWorkoutPlans
extension User {

    @objc(addHasWorkoutPlansObject:)
    @NSManaged public func addToHasWorkoutPlans(_ value: WorkoutPlan)

    @objc(removeHasWorkoutPlansObject:)
    @NSManaged public func removeFromHasWorkoutPlans(_ value: WorkoutPlan)

    @objc(addHasWorkoutPlans:)
    @NSManaged public func addToHasWorkoutPlans(_ values: NSSet)

    @objc(removeHasWorkoutPlans:)
    @NSManaged public func removeFromHasWorkoutPlans(_ values: NSSet)

}

extension User : Identifiable {

}
