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
    
    var isEditingWorkoutPlan: Bool = false
    var workoutPlan: WorkoutPlan?

    @IBOutlet weak var workoutPlanNameTextField: UITextField!
    @IBOutlet weak var addWorkoutPlanButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for layout set up
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
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
        
        configureViewForMode()
    }
    
    private func configureViewForMode() {
        if isEditingWorkoutPlan, let plan = workoutPlan {
            // for editing an existing workout plan
            workoutPlanNameTextField.text = plan.name
            selectedExercises = Set(plan.hasExercises?.allObjects as? [ExerciseLibrary] ?? [])
            addWorkoutPlanButton.setTitle("Update Workout Plan", for: .normal)
        } else {
            // for adding a new workout plan
            workoutPlanNameTextField.text = ""
            selectedExercises.removeAll()
            addWorkoutPlanButton.setTitle("Add Workout Plan", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExercises()
        collectionView.reloadData()
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

        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutPlanExerciseCell", for: indexPath) as? WorkoutPlanExerciseCollectionViewCell else {
            fatalError("Unable to dequeue WorkoutPlanExerciseCollectionViewCell")
        }
        let exercise = exercises[indexPath.row]
        cell.configure(with: exercise)
        
        //cell.isSelected = selectedExercises.contains(exercises[indexPath.row])
        
        if selectedExercises.contains(exercise) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.isSelected = true
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
            cell.isSelected = false
        }
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
        
        if isEditingWorkoutPlan {  // Editing an existing workout plan
            guard let plan = workoutPlan else { return }
            plan.name = workoutPlanName
            plan.hasExercises = NSSet(array: Array(selectedExercises))
            
            let success = DBManager.shared.saveData()
            if success {
                showAlert(message: "Workout plan updated successfully.")
            } else {
                showAlert(message: "Failed to update workout plan.")
            }
        } else {  // Adding a new workout plan
            let success = DBManager.shared.addWorkoutPlan(workoutPlan: WorkoutPlanModel(name: workoutPlanName), user: currentUser!, exercises: Array(selectedExercises))
            if success {
                showAlert(message: "Workout plan added successfully.")
            } else {
                showAlert(message: "Failed to add workout plan.")
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
