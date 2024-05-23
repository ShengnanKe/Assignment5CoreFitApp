//
//  AdminExerciseTableViewCell.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
//

import UIKit

class AdminExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var muscleGroupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with exercise: ExerciseLibrary) {
        exerciseNameLabel.text = exercise.exerciseName
        muscleGroupLabel.text = exercise.muscleGroup
    }
}
