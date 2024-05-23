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
    var selectedExercises: Set<ExerciseLibrary> = []


    @IBOutlet weak var workoutPlanNameTextField: UITextField!
    @IBOutlet weak var addWorkoutPlanButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        
        workoutPlanNameTextField.placeholder = "Enter Workout Plan Name: "
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        if let user = currentUser {
            print("Current user's username is: \(user.username ?? "something wrong")")
            
        } else {
            print("UserAddWorkoutPlanViewController: No current user found")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExercises()
    }
    
    func loadExercises(){ // load all admin exercises and userdefined exercise
        exercises.removeAll()  // Clear the current list of exercises
        
        if let user = currentUser {
        
            if let userExercises = user.createdExercises?.allObjects as? [ExerciseLibrary] {
                exercises.append(contentsOf: userExercises) // show this current user created exercises
            }
            
            // add admin exercises also append to here for this user ro select
            if let adminExercise = DBManager.shared.preloadAdminExercises() as? [ExerciseLibrary]{
                exercises.append(contentsOf: adminExercise)
            }
            
        } else {
            print("No current user found")
        }
        
        // need to add admin defined exercise here too
        
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutPlanExerciseCell", for: indexPath) as? WorkoutPlanExerciseCollectionViewCell else {
            fatalError("Unable to dequeue WorkoutPlanExerciseCollectionViewCell")
        }
        cell.configure(with: exercises[indexPath.row])
        cell.isSelected = selectedExercises.contains(exercises[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exercise = exercises[indexPath.row]
        selectedExercises.insert(exercise)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let exercise = exercises[indexPath.row]
        selectedExercises.remove(exercise)
    }

    
    @IBAction func addWorkoutPlanButtonTapped(_ sender: UIButton) {
        guard let workoutPlanName = workoutPlanNameTextField.text, !workoutPlanName.isEmpty else {
            showAlert(message: "Please enter a workout name.")
            return
        }
        
        guard !selectedExercises.isEmpty else {
            showAlert(message: "Please select at least one exercise.")
            return
        }
        
        let workoutPlanModel = WorkoutPlanModel(name: workoutPlanName)
        
        let success = DBManager.shared.addWorkoutPlan(workoutPlan: workoutPlanModel, user: self.currentUser!, exercises: Array(selectedExercises))
        
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
