//
//  LogInViewController.swift
//  Flash Chat
//
//  Created by Florentin Lupascu on 16/07/2018.
//
//  This is the view controller where users login


import UIKit
import Firebase
import SCLAlertView

class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Log in the user
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SwiftSpinner.show("Loading Messages")
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            
            if error != nil{
                SCLAlertView().showError("Try again", subTitle: "Username or password is incorrect.")
                SwiftSpinner.hide()
            }
            else{
                SwiftSpinner.hide()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        } 
    }
}  
