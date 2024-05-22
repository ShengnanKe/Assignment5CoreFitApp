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
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        loadExercises()
    }

    func loadExercises() {
        exercises.removeAll()  // Clear the current list of exercises
        
        if let userExercises = currentUser?.createdExercises?.allObjects as? [ExerciseLibrary] {
            exercises.append(contentsOf: userExercises)
        }

        if let adminUser = currentUser?.managedObjectContext?.registeredObjects.first(where: {
            ($0 as? User)?.username == "admin"
        }) as? User, let adminExercises = adminUser.createdExercises?.allObjects as? [ExerciseLibrary] {
            exercises.append(contentsOf: adminExercises)
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
}
