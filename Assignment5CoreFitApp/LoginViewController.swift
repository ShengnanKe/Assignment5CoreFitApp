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
        
            navigateToNextScreen(user: user)
            print("Login successful for user: \(user.username ?? "Unknown")")
        } else {
            showAlert(message: "Invalid username or password.")
        }
    }
    
    func navigateToNextScreen(user: User) {
        if user.isAdmin {
            performSegue(withIdentifier: "AdminExerciseListViewController", sender: nil)
        } else {
            performSegue(withIdentifier: "UserExerciseListViewController", sender: nil)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
