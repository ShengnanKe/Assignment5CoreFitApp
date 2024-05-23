//
//  UserExerciseListViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import UIKit
import CoreData

class UserExerciseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var addWorkoutPlanButton: UIButton!
    
    var exercises: [ExerciseLibrary] = []
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExercises()
    }

    func loadExercises() {
        exercises.removeAll()
        if let userExercises = currentUser?.createdExercises?.allObjects as? [ExerciseLibrary] {
            exercises.append(contentsOf: userExercises)
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserExerciseCell", for: indexPath) as? UserExerciseTableViewCell else {
            fatalError("Unable to dequeue UserExerciseTableViewCell")
        }
        let exercise = exercises[indexPath.row]
        cell.configure(with: exercise)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteExercise(at: indexPath)
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            self.performSegue(withIdentifier: "userAddExercise", sender: indexPath.row)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func deleteExercise(at indexPath: IndexPath) {
        let exerciseToDelete = exercises[indexPath.row]
        let success = DBManager.shared.deleteExercise(exercise: exerciseToDelete)
        if success {
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else {
            showAlert(message: "Failed to delete the exercise.")
        }
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "userAddExercise", sender: currentUser)
    }
    
    @IBAction func addWorkoutPlan(_ sender: UIButton) {
        performSegue(withIdentifier: "showUserWorkoutPlans", sender: currentUser)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userAddExercise" {
            guard let destinationVC = segue.destination as? AddExerciseViewController else { return }
            
            if let user = sender as? User { // or adding a new exercise
                destinationVC.currentUser = user
                destinationVC.isEditingExercise = false
            } else if let index = sender as? Int { // for editing existing exercise
                destinationVC.exerciseToEdit = exercises[index]
                destinationVC.currentUser = currentUser
                destinationVC.isEditingExercise = true
            }
        } else if segue.identifier == "showUserWorkoutPlans"{
            if let destinationVC = segue.destination as? UserWorkoutPlansViewController, let data = sender as? User {
                destinationVC.currentUser = data
            }
        }
    }
}
