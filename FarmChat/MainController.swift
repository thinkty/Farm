//
//  MainController.swift
//  FarmChat
//
//  Created by Kim TY on 11/11/18.
//  Copyright © 2018 Kim TY. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //protocols for tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //hardcoded
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutButtonDidPressed(_ sender: Any) {
        
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
