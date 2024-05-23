//
//  UserWorkoutPlansViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
//

import UIKit
import CoreData

class UserWorkoutPlansViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addWorkoutPlanButton: UIButton!
    
    var workoutPlans: [WorkoutPlan] = []
    var managedContext: NSManagedObjectContext!
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        if let user = currentUser {
            print("UserWorkoutPlansViewController: Current user's username is: \(user.username ?? "something wrong")")
            
        } else {
            print("UserWorkoutPlansViewController: No current user found")
        }
        
        //loadWorkoutPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadWorkoutPlans()
    }
    
    func loadWorkoutPlans() {
        if let plans = currentUser?.hasWorkoutPlans?.allObjects as? [WorkoutPlan] {
            workoutPlans = plans
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutPlanCell", for: indexPath) as? UserWorkoutPlansTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserWorkoutPlansTableViewCell.")
        }
        let workoutPlan = workoutPlans[indexPath.row]
        cell.configure(with: workoutPlan)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func addWorkoutPlanButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "userAddWorkoutPlans", sender: currentUser)
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            self.performSegue(withIdentifier: "userAddWorkoutPlans", sender: indexPath.row)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteWorkoutPlan(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    func deleteWorkoutPlan(at indexPath: IndexPath) {
        let workoutPlan = workoutPlans[indexPath.row]
        let success = DBManager.shared.deleteWorkoutPlan(workoutPlan: workoutPlan)
        if success {
            workoutPlans.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            showAlert(message: "Workout plan deleted successfully.")
        } else {
            showAlert(message: "Failed to delete workout plan.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userAddWorkoutPlans" {
            guard let destinationVC = segue.destination as? UserAddWorkoutPlanViewController else { return }
            
            if let index = sender as? Int {
                // Editing workout plan
                destinationVC.workoutPlan = workoutPlans[index]
                destinationVC.isEditingWorkoutPlan = true
                destinationVC.currentUser = currentUser
            } else if sender is User {
                // Adding a new workout plan
                destinationVC.isEditingWorkoutPlan = false
                destinationVC.currentUser = currentUser
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // view details of the existing workplan
//        let workoutPlan = workoutPlans[indexPath.row]
//        performSegue(withIdentifier: "userAddWorkoutPlans", sender: workoutPlan)
//    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
