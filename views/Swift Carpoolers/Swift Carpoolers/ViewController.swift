//
//  ViewController.swift
//  Swift Carpoolers
//
//  Created by Timmy Lee on 11/7/18.
//  Copyright © 2018 Hell on wheels. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var username : String = "";
//    var firstName : String = "";
//    var lastName : String = "";
//    var password : String = "";
//    var phoneNumber : String = "";

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
//    @IBAction func registerUser(_ sender: Any) {
//        // Make API request with data
//        print(username)
//        print(firstName)
//        print(lastName)
//        print(password)
//        print(phoneNumber)
//    }
    @IBAction func register(_ sender: Any) {
        print(username.text!)
        print(firstName.text!)
        print(lastName.text!)
        print(password.text!)
        print(phoneNumber.text!)
        
        let requestBody: [String: String] = [
            "username": username.text!,
            "firstName": firstName.text!,
            "lastName": lastName.text!,
            "password": password.text!,
            "phoneNumber": phoneNumber.text!
        ]
        
        print(requestBody)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}
