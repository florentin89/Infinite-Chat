//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Florentin Lupascu on 16/07/2018.
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SCLAlertView

class RegisterViewController: UIViewController {
    
    //Linked Interface
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    // Life Cycle States
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Set up a new user on our Firbase database
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SwiftSpinner.show("Loading Registration")
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            if error != nil{
                SCLAlertView().showError("Try again", subTitle: "Registration Failed.")
                SwiftSpinner.hide()
            }
            else{
                // success
                SwiftSpinner.hide()
                DispatchQueue.main.async {
                    SCLAlertView().showSuccess("Welcome", subTitle: "\(Auth.auth().currentUser!.email!), \nyou registered with success !")
                }
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
}
