//
//  ExerciseLibrary+CoreDataProperties.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//
//

import Foundation
import CoreData


extension ExerciseLibrary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseLibrary> {
        return NSFetchRequest<ExerciseLibrary>(entityName: "ExerciseLibrary")
    }

    @NSManaged public var ownerUsername: String?
    @NSManaged public var exerciseDescription: String?
    @NSManaged public var exerciseName: String?
    @NSManaged public var mediaPath: String?
    @NSManaged public var muscleGroup: String?
    @NSManaged public var createdByUser: User?
    @NSManaged public var belongsToWorkoutPlans: NSSet?

}

// MARK: Generated accessors for belongsToWorkoutPlans
extension ExerciseLibrary {

    @objc(addBelongsToWorkoutPlansObject:)
    @NSManaged public func addToBelongsToWorkoutPlans(_ value: WorkoutPlan)

    @objc(removeBelongsToWorkoutPlansObject:)
    @NSManaged public func removeFromBelongsToWorkoutPlans(_ value: WorkoutPlan)

    @objc(addBelongsToWorkoutPlans:)
    @NSManaged public func addToBelongsToWorkoutPlans(_ values: NSSet)

    @objc(removeBelongsToWorkoutPlans:)
    @NSManaged public func removeFromBelongsToWorkoutPlans(_ values: NSSet)

}

extension ExerciseLibrary : Identifiable {

}
