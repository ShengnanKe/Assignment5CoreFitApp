//
//  AddExerciseViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/22/24.
//

import UIKit
import CoreData

class AddExerciseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var muscleGroupTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var addExerciseButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var selectedImagePath: String?
    
    var currentUser: User?
    var isEditingExercise: Bool = false // is for adding new exercise or for editing
    var exerciseToEdit: ExerciseLibrary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.placeholder = "User Enter Exercise Name: "
        muscleGroupTextField.placeholder = "Enter Muscle Group Name: "
        
        imagePicker.delegate = self
        
        configureViewForMode()
    }
    
    private func configureViewForMode() {
        if isEditingExercise, let exercise = exerciseToEdit {
            // for editing
            nameTextField.text = exercise.exerciseName
            muscleGroupTextField.text = exercise.muscleGroup
            descriptionTextView.text = exercise.exerciseDescription
            loadExistingImage(from: exercise.mediaPath)
            addExerciseButton.setTitle("Update Exercise", for: .normal)
        } else {
            // for adding new exercise
            nameTextField.text = ""
            muscleGroupTextField.text = ""
            descriptionTextView.text = ""
            exerciseImageView.image = nil
            addExerciseButton.setTitle("Add Exercise", for: .normal)
        }
    }
    
    private func loadExistingImage(from path: String?) {
        guard let imagePath = path, !imagePath.isEmpty,
              let image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(imagePath).path) else {
            exerciseImageView.image = UIImage(named: "default-placeholder")
            return
        }
        exerciseImageView.image = image
    }
 
 
    @IBAction func addOrUpdateExerciseButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let muscleGroup = muscleGroupTextField.text, !muscleGroup.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty else {
            showAlert(message: "Please fill out all fields.")
            return
        }
        
        let imagePath = selectedImagePath ?? exerciseToEdit?.mediaPath ?? "default/path"

        if let exercise = exerciseToEdit {
            // Update existing exercise
            exercise.exerciseName = name
            exercise.exerciseDescription = description
            exercise.mediaPath = imagePath
            exercise.muscleGroup = muscleGroup
        } else {
            // Create new exercise
            let newExercise = ExerciseModel(exerciseName: name, exerciseDescription: description, mediaPath: imagePath, muscleGroup: muscleGroup)
            let success = DBManager.shared.addExercise(exercise: newExercise, user: self.currentUser!)
        }
        
        let success = DBManager.shared.saveData()
        if success {
            showAlert(message: "Exercise \(exerciseToEdit != nil ? "updated" : "added") successfully.")
        } else {
            showAlert(message: "Failed to \(exerciseToEdit != nil ? "update" : "add") exercise.")
        }
    }
    
    @IBAction func chooseImageTapped(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        exerciseImageView.image = image
        
        selectedImagePath = saveImageAndGetPath(image: image)
        // when image selected change the button text
        chooseImageButton.setTitle("Image Selected", for: .normal)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func saveImageAndGetPath(image: UIImage) -> String {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return "default/path"
        }
        
        //let fileManager = FileManager.default
        let docDirectory = getDocumentsDirectory()
        
        let fileName = "\(UUID().uuidString).jpg"
        let filePath = docDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: filePath)
            print("Saved image to: \(filePath)")
            return fileName
        } catch {
            print("Error!! Cannot save image: \(error)")
            return "default/path"
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
