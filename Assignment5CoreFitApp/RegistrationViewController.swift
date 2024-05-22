//
//  RegistrationViewController.swift
//  Assignment5CoreFitApp
//
//  Created by KKNANXX on 5/21/24.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var adminUserLabel: UILabel!
    @IBOutlet weak var isAdminSwitch: UISwitch!
    
    var users: [User] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholder = "Enter Username here: "
        passwordTextField.placeholder = "Enter Password here: "
        
        let url = NSPersistentContainer.defaultDirectoryURL()
        print("url: ", url)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton){
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter username and password.")
            return
        }
        
        let isAdmin = isAdminSwitch.isOn
        let newUser = UserModel(username: username, password: password, isAdmin: isAdmin)
        
        let success = DBManager.shared.addUser(user: newUser)
        if success {
            showAlert(message: "User registered successful")
            print("User registered successful")
        } else {
            showAlert(message: "Failed to register")
            print("Failed to register")
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
