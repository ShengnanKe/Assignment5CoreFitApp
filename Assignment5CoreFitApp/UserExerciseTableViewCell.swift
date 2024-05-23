//
//  UserExerciseTableViewCell.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
//

import UIKit

class UserExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var muscleGroupLabel: UILabel!
    
    func configure(with exercise: ExerciseLibrary) {
        exerciseNameLabel.text = exercise.exerciseName
        muscleGroupLabel.text = exercise.muscleGroup
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
