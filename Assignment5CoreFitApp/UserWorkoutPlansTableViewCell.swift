//
//  UserWorkoutPlansTableViewCell.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
//

import UIKit

class UserWorkoutPlansTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutPlanLabel: UILabel!
    
    func configure(with workoutPlan: WorkoutPlan) {
        workoutPlanLabel.text = workoutPlan.name
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
