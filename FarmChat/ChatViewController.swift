//
//  ChatViewController.swift
//  FarmChat
//
//  Created by Kim TY on 11/18/18.
//  Copyright © 2018 Kim TY. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    
    @IBOutlet var userMessageView: UITextView!
    @IBOutlet var userName: UITextField!
    @IBOutlet var OpponentName: UITextField!
    @IBOutlet var OpponentMessageView: UITextView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        userName.delegate = self
        userMessageView.delegate = self
        OpponentName.delegate = self
        OpponentMessageView.delegate = self
        
        OpponentMessageView.layer.cornerRadius = 15.0
        OpponentMessageView.layer.borderWidth = 2.0
        userMessageView.layer.cornerRadius = 15.0
        userMessageView.layer.borderWidth = 2.0
        
        // Do any additional setup after loading the view.
        
        retrieveMessages()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == userName || textField == OpponentName {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 360
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @IBAction func sendPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        if messageTextField.text == "" {
            self.messageTextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextField.text = ""
        } else {
        
            let messageDB = Database.database().reference().child("Messages")
        
            let messageDictionary = ["Sender": (Auth.auth().currentUser?.uid)!, "MessageBody": messageTextField.text!]
        
            messageDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(messageDictionary) {
                (error, reference) in
            
                if error != nil {
                    print(error!)
                }
                else {
                    print("Message saved on the database successfully!")
                }
            
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
        
        retrieveMessages()
    } //send pressed method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendPressed(self)
        return true;
    }
    
    //retrieve message
    func retrieveMessages() {
        let MessageDB = Database.database().reference().child("Messages").child((Auth.auth().currentUser?.uid)!)
        let usernameDB = Database.database().reference().child("Usernames")
        var text: String = ""
        var sender: String = ""
        //var senderUsername: String = ""
        
        MessageDB.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            text = snapshotValue["MessageBody"]! //give the text
            sender = snapshotValue["Sender"]! //give the sender
            
            print("\nCurrent User  : ", Auth.auth().currentUser!.uid)
            print("Sender        : ", sender)
            print("Text          : ", text)
            
            usernameDB.child(sender).observeSingleEvent(of: .value, with: { (snapshot) in
                let userDict = snapshot.value as! [String: Any]
                
                let username = userDict["username"] as! String
                if (sender == Auth.auth().currentUser!.uid) {
                    self.userName.text = username
                    self.userMessageView.text = text
                    print("Username      : ", username)
                    print("message       : ", text)
                } else {
                    self.OpponentMessageView.text = text
                    self.OpponentName.text = username
                    print("Username      : ", username)
                    print("message       : ", text)
                }
            })
            /*
            usernameDB.observe(.childAdded, with: { (snapshot) in
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                
                senderUsername = snapshotValue["username"]! //give the username
                //print("Username      : ", senderUsername)
                print("Text          : ", text)
                
                if (sender == Auth.auth().currentUser!.uid) {
                    self.userName.text = senderUsername
                    self.userMessageView.text = text
                    print("Username      : ", senderUsername)
                    print("message       : ", text)
                } else {
                    self.OpponentMessageView.text = text
                    self.OpponentName.text = senderUsername
                    print("Username      : ", senderUsername)
                    print("message       : ", text)
                }
                
                //TODO: do i need an else case in case the sender is not the current user?
                //      How will I handle that case?
            }) */
        })
    } //retrieve messages method


}
