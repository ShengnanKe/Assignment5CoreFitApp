//
//  WorkoutPlan+CoreDataProperties.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
//
//

import Foundation
import CoreData


extension WorkoutPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutPlan> {
        return NSFetchRequest<WorkoutPlan>(entityName: "WorkoutPlan")
    }

    @NSManaged public var name: String?
    @NSManaged public var belongsToUser: User?
    @NSManaged public var hasExercises: NSSet?

}

// MARK: Generated accessors for hasExercises
extension WorkoutPlan {

    @objc(addHasExercisesObject:)
    @NSManaged public func addToHasExercises(_ value: ExerciseLibrary)

    @objc(removeHasExercisesObject:)
    @NSManaged public func removeFromHasExercises(_ value: ExerciseLibrary)

    @objc(addHasExercises:)
    @NSManaged public func addToHasExercises(_ values: NSSet)

    @objc(removeHasExercises:)
    @NSManaged public func removeFromHasExercises(_ values: NSSet)

}

extension WorkoutPlan : Identifiable {

}
