//
//  LoginViewController.swift
//  PowerupiOS
//
//  Created by Diamonique Danner on 4/15/19.
//  Copyright © 2019 Danner Op., LLC. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        guard let password = passwordText.text else { return }
        
        guard let email = emailText.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password){
            user, error in
            if error == nil && user != nil {
                self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
            } else {
                print("unsuccessful")
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
