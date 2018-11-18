//
//  ViewController.swift
//  FarmChat
//
//  Created by Kim TY on 11/10/18.
//  Copyright © 2018 Kim TY. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var inputCustomName: UITextField!
    
    @IBAction func startAnonymouslyDidTapped(_ sender: Any) {
        if inputCustomName.hasText {
            userName = inputCustomName.text ?? getAccountName()
            //print("\(userName)")
        } else {
            userName = getAccountName()
        }
        print("\(userName)")
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print("Sign in failed: ", error.localizedDescription)
            } else {
                print("Signed in anonymously")
                self.performSegue(withIdentifier: "toMain", sender: self)
                
            }
        }
    }
    
}

