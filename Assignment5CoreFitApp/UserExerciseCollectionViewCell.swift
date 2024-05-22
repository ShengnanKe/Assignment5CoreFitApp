//
//  UserExerciseCollectionViewCell.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import UIKit

class UserExerciseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(with exercise: ExerciseLibrary) {
        nameLabel.text = exercise.exerciseName
        detailLabel.text = "Muscle group: \(exercise.muscleGroup ?? "N/A")"
    }
    
}
