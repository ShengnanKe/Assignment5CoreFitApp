//
//  UserAddExerciseViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//


import UIKit
import CoreData

class UserAddExerciseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var muscleGroupTextField: UITextField!
    //@IBOutlet weak var addExerciseDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var addExerciseButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var selectedImagePath: String?
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.placeholder = "User Enter Exercise Name: "
        muscleGroupTextField.placeholder = "Enter Muscle Group Name: "
        
        imagePicker.delegate = self
        if let user = currentUser {
            print("Current user's username is: \(user.username ?? "something wrong")")
            
        } else {
            print("No current user found")
            
        }
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let muscleGroup = muscleGroupTextField.text, !muscleGroup.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              let imagePath = selectedImagePath, !imagePath.isEmpty else {
            showAlert(message: "Please fill out all fields and select an image.")
            return
        }
        
        let exerciseModel = ExerciseModel(ownerUsername: (currentUser?.username)!, exerciseName: name, exerciseDescription: description, mediaPath: imagePath, muscleGroup: muscleGroup)
        
        let success = DBManager.shared.addExercise(exercise: exerciseModel)
        if success {
            showAlert(message: "Exercise added successfully.")
        } else {
            showAlert(message: "Failed to add exercise.")
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
        
        let fileManager = FileManager.default
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
