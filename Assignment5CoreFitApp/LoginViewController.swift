//
//  LoginViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholder = "Enter Username here: "
        passwordTextField.placeholder = "Enter Password here: "
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter both username and password.")
            return
        }

        let loginResult = DBManager.shared.loginUser(username: username, password: password)
        if loginResult.success, let user = loginResult.user {
            self.currentUser = user
            print("Login successful for user: \(user.username ?? "Unknown")")

            let segueIdentifier = user.isAdmin ? "showAdminExerciseList" : "showUserExerciseList"
            performSegue(withIdentifier: segueIdentifier, sender: currentUser)
        } else {
            showAlert(message: "Invalid username or password.")
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserExerciseList" {
            if let destinationVC = segue.destination as? UserExerciseListViewController, let data = sender as? User {
                destinationVC.currentUser = data
            }
            // destinationVC.currentUser = self.currentUser
        } else if segue.identifier == "showAdminExerciseList",
                  let destinationVC = segue.destination as? AdminExerciseListViewController ,let data = sender as? User {
            destinationVC.currentUser = data
        }
    }
    
}
