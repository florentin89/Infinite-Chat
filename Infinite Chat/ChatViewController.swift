//
//  ViewController.swift
//  Flash Chat
//
//  Created by Florentin Lupascu on 16/07/2018.
//

import UIKit
import Firebase
import ChameleonFramework
import Kingfisher
import EFInternetIndicator
import SCLAlertView

class ChatViewController: UIViewController, UITextFieldDelegate, InternetStatusIndicable {
    
    // Declare instance variables here
    var messageArray: [Message] = [Message]()
    var internetConnectionIndicator:InternetViewIndicator?
    
    // Linked interfaces
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    // Life Cycle States
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startMonitoringInternet()
        
        //Set yourself as the delegate and datasource here:
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        //Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        //Set the tapGesture here
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        //Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
    }
    
    //Declare tableViewTapped here
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 320 // size of keyboard
            self.view.layoutIfNeeded()
        }
    }
    
    //Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50 // set the field back to original size
            self.view.layoutIfNeeded()
        }
    }
    
    //Send the message to Firebase and save it in the database
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil{
                SCLAlertView().showError("Error", subTitle: "Message cannot be sent.")
            }
            else{
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }
    
    //Create the retrieveMessages method here
    func retrieveMessages(){
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) {
            (snapshot) in
            
           let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            
            self.messageTableView.reloadData()
        }
    }
    
    //Log out the user and send them back to WelcomeViewController
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do{
            try Auth.auth().signOut()
            SCLAlertView().showSuccess("Success", subTitle: "You logged out successful !")
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            SCLAlertView().showError("Try again", subTitle: "There was a problem with signing out.")
        }
    }
}

// Set protocol methods for TableView
extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell") as! CustomMessageCell
        //let avatarURL = "https://api.adorable.io/avatars/150/\(messageArray[indexPath.row].sender)"
        let avatarURL = "https://robohash.org/\(messageArray[indexPath.row].sender)"
        let resourceAvatar = ImageResource(downloadURL: URL(string: avatarURL)!, cacheKey: avatarURL)
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
       
        DispatchQueue.main.async {
            cell.avatarImageView.kf.setImage(with: resourceAvatar)
        }
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            // Message we sent
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else{
            cell.messageBackground.backgroundColor = UIColor.flatForestGreen()
        }
        
        return cell
    }
}
