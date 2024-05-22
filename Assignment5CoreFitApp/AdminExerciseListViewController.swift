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
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
