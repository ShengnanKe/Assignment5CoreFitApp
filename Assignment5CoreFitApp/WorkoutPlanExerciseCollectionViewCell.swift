//
//  WorkoutPlanExerciseCollectionViewCell.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
//

import UIKit

class WorkoutPlanExerciseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseMuscleLabel: UILabel!
    
    func configure(with exercise: ExerciseLibrary) {
        exerciseNameLabel.text = exercise.exerciseName
        exerciseMuscleLabel.text = exercise.muscleGroup
        self.contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white  // Change color based on selection
    }
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white
        }
    }
    
    
    
}
