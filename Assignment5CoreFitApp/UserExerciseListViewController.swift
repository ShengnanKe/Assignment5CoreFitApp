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
    var managedContext: NSManagedObjectContext!
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 100
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        managedContext = appDelegate.persistentContainer.viewContext
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
            if let destinationVC = segue.destination as? AddExerciseViewController, let data = sender as? User {
                destinationVC.currentUser = data
            }
        } else if segue.identifier == "showUserWorkoutPlans"{
            if let destinationVC = segue.destination as? UserWorkoutPlansViewController, let data = sender as? User {
                destinationVC.currentUser = data
            }
        }
    }
}
