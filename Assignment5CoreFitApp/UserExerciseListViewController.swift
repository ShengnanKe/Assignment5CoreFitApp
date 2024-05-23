//
//  UserExerciseListViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import UIKit
import CoreData

class UserExerciseListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var addWorkoutPlanButton: UIButton!
    
    var exercises: [ExerciseLibrary] = []
    var managedContext: NSManagedObjectContext!
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 120)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        //print(currentUser) 可以了
        
        //loadExercises()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExercises()
    }

    func loadExercises() {
        exercises.removeAll()  // Clear the current list of exercises
        
        // show this current user created exercises
        if let userExercises = currentUser?.createdExercises?.allObjects as? [ExerciseLibrary] {
            exercises.append(contentsOf: userExercises)
        }
        
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserExerciseCell", for: indexPath) as? UserExerciseCollectionViewCell else {
            fatalError("Unable to dequeue UserExerciseCollectionViewCell")
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
