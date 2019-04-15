//
//  SignupViewController.swift
//  PowerupiOS
//
//  Created by Diamonique Danner on 4/1/19.
//  Copyright © 2019 Danner Opp., LLC. All rights reserved.
//
import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var confirmPasswordText: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        guard let email = emailText.text else { return }
        if passwordText.text == confirmPasswordText.text {
            guard let password = passwordText.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) {
                user, error in
                if error == nil && user != nil {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.usernameText.text
                    changeRequest?.commitChanges{
                        error in
                        if error == nil {
                            print("user display name changed")
                        } else {
                            print(error?.localizedDescription)
                        }
                    }
                    
                    self.performSegue(withIdentifier: "fromSignupToMain", sender: self)
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
