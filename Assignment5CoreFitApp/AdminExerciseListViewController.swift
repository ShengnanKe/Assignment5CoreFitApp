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
    @IBOutlet weak var tableView: UITableView!  // Changed from collectionView
    @IBOutlet weak var addExerciseButton: UIButton!
    
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
    
    // UITableView DataSource methods
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
    
    // Optional: UITableView Delegate method for handling row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection if needed
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "adminAddExercise", sender: currentUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adminAddExercise" {
            if let destinationVC = segue.destination as? AddExerciseViewController, let user = sender as? User {
                destinationVC.currentUser = user
            }
        }
    }
}
