//
//  AdminExerciseCollectionViewCell.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import UIKit

class AdminExerciseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var muscleGroupLabel: UILabel!
    
    func configure(with exercise: ExerciseLibrary) {
        exerciseNameLabel.text = exercise.exerciseName
        muscleGroupLabel.text = exercise.muscleGroup
    }
    
}
