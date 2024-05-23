//
//  AdminExerciseListViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//
import UIKit
import CoreData

class AdminExerciseListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var adminExerciseLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addExerciseButton: UIButton!
    
    var exercises: [ExerciseLibrary] = []
    var currentUser: User? // var adminUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10  
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAdminExercises()
    }
    
    func loadAdminExercises() {
        if let adminExercises = currentUser?.createdExercises?.allObjects as? [ExerciseLibrary] {
            self.exercises = adminExercises
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdminExerciseCell", for: indexPath) as? AdminExerciseCollectionViewCell else {
            fatalError("Unable to dequeue AdminExerciseCollectionViewCell")
        }
        cell.configure(with: exercises[indexPath.row])
        return cell
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "adminAddExercise", sender: currentUser)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adminAddExercise" {
            if let destinationVC = segue.destination as? AddExerciseViewController, let data = sender as? User {
                destinationVC.currentUser = data
            }
        }
    }
}
