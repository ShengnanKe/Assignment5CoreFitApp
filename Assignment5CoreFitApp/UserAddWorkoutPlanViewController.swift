//
//  UserAddWorkoutPlanViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import UIKit

class UserAddWorkoutPlanViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var currentUser: User?
    var exercises: [ExerciseLibrary] = []

    @IBOutlet weak var workoutPlanNameTextField: UITextField!
    @IBOutlet weak var addWorkoutPlanButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutPlanNameTextField.placeholder = "Enter Workout Plan Name: "
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let user = currentUser {
            print("Current user's username is: \(user.username ?? "something wrong")")
            
        } else {
            print("No current user found")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExercises()
    }
    
    func loadExercises(){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    @IBAction func addWorkoutPlanButtonTapped(_ sender: UIButton) {
        guard let workoutPlanName = workoutPlanNameTextField.text, !workoutPlanName.isEmpty else {
            showAlert(message: "Please enter a workout name.")
            return
        }
        let workoutPlanModel = WorkoutPlanModel(name: workoutPlanName)
        
        let success = DBManager.shared.addWorkoutPlan(workoutPlan: WorkoutPlanModel, user: self.currentUser!, exercises: )
        
        if success {
            showAlert(message: "Workout plan added successfully.")
        } else {
            showAlert(message: "Failed to add workout plan.")
        }

    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
