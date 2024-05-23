//
//  AdminExerciseListViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//


import UIKit
import CoreData

class AdminExerciseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var adminExerciseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addExerciseButton: UIButton!
    
    var managedContext: NSManagedObjectContext!
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
        loadAdminExercises()
    }
    
    func loadAdminExercises() {
        if let adminExercises = currentUser?.createdExercises?.allObjects as? [ExerciseLibrary] {
            self.exercises = adminExercises
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdminExerciseCell", for: indexPath) as? AdminExerciseTableViewCell else {
            fatalError("Unable to dequeue AdminExerciseTableViewCell")
        }
        cell.configure(with: exercises[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true  // Allows the row to be editable
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteExercise(at: indexPath)
            completionHandler(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            self.performSegue(withIdentifier: "adminAddExercise", sender: indexPath.row)
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
            print("Failed to delete the exercise from the database.")
        }
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "adminAddExercise", sender: currentUser)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // to see details of this exercise -> view only
//        performSegue(withIdentifier: "adminAddExercise", sender: indexPath.row)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adminAddExercise" {
            guard let destinationVC = segue.destination as? AddExerciseViewController else { return }
            
            if let user = sender as? User {
                // Setting up for adding a new exercise
                destinationVC.currentUser = user
                destinationVC.isEditingExercise = false
            } else if let index = sender as? Int {
                // Setting up for editing an existing exercise
                destinationVC.exerciseToEdit = exercises[index]
                destinationVC.currentUser = currentUser
                destinationVC.isEditingExercise = true
            }
        }
    }
    
}
