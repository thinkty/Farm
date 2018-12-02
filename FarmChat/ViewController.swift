//
//  ViewController.swift
//  FarmChat
//
//  Created by Kim TY on 11/10/18.
//  Copyright © 2018 Kim TY. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    var colorArray = [["red", "orange", "yellow", "green", "blue", "purple", "brown", "magenta", "tan", "cyan", "olive", "maroon", "navy", "silver", "violet", "pink", "black", "white", "gray"], ["beautiful", "clean", "adorable", "fancy", "funky", "old-fashioned", "plain"], ["clever", "dead", "famous", "intelligent", "important", "strong", "powerful", "shy", "rich", "wrong"], ["brave", "calm", "delightful", "happy", "jolly", "kind", "nice", "proud", "silly"], ["angry", "clumsy", "naughty", "fierce", "grumpy", "lazy", "mysterious", "nervous", "scary", "weird"], ["chubby", "crooked", "flat", "high", "skinny", "big", "tiny"], ["colossal", "fat", "gigantic", "great", "huge", "large", "little", "massive", "puny", "short", "small", "tall", "tiny", "hot"], ["loud", "noisy", "whispering", "thundering"]]
    
    var animalArray = ["cat", "bird", "dog", "sheep", "cattle", "goat", "horse", "chicken", "pig", "rabbit", "donkey", "duck", "llama", "mule", "calf", "pony", "emu", "goose", "cricket", "deer", "worm"]
    
    func getAccountName() -> String { //create random name
        let firstIndexNum : Int  = Int.random(in: 0 ... 7)
        let secondIndexNum : Int = Int.random(in: 0 ... colorArray[firstIndexNum].count - 1)
        return colorArray[firstIndexNum][secondIndexNum] + " " + animalArray[Int.random(in: 0 ... 7)]
    }
    
    var userName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputCustomName.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: inputCustomName.frame.size.height - width, width: inputCustomName.frame.size.width, height: inputCustomName.frame.size.height)
        border.borderWidth = width
        inputCustomName.layer.addSublayer(border)
        inputCustomName.layer.masksToBounds = true
        
        startButton.layer.cornerRadius = 15.0
        startButton.layer.borderWidth = 2.0
        
    }
    
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var inputCustomName: UITextField!
    
    @IBAction func startAnonymouslyDidTapped(_ sender: Any) {
        
        if inputCustomName.hasText {
            userName = inputCustomName.text!
        } else {
            userName = getAccountName()
        }
        print("Anonymous user created with the username: \(userName).")
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print("Sign in failed: ", error.localizedDescription)
            } else {
                print("Signed in anonymously")
                
                //TODO: Let the username be saved so that it can be accessed anytime
                let usernameDB = Database.database().reference().child("Usernames")
                let usernameDictionary = ["username": self.userName]
                usernameDB.child((Auth.auth().currentUser?.uid)!).setValue(usernameDictionary)
                
                let messageDB = Database.database().reference().child("Messages")
                
                let messageDictionary = ["Sender": (Auth.auth().currentUser?.uid)!, "MessageBody": "\(self.userName) has entered the chatroom"]
                
                messageDB.child((Auth.auth().currentUser?.uid)!).setValue(messageDictionary) {
                    (error, reference) in
                    
                    if error != nil {
                        print(error!)
                    }
                    else {
                        print("Message saved on the database successfully!")
                        self.performSegue(withIdentifier: "toMain", sender: self)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startAnonymouslyDidTapped(self)
        return true
    }
    
}
