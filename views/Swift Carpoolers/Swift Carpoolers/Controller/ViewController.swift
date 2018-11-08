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

    @IBOutlet weak var emailAddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
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
    
    @IBAction func LoginButton(_ sender: UIButton) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if(emailTest.evaluate(with: emailAddressText.text) && passwordText.hasText){
            errorLabel.isHidden = true
            print(true)
        } else {
            errorLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(errorLabel != nil){
           errorLabel.isHidden = true
        }

        
        
        
//        let vc = navigationController?.viewControllers.first
//        let button = UIBarButtonItem(barButtonSystemItem: "Go Back", target: self, action: testing)
//        vc?.navigationItem.backBarButtonItem = button
    }

    
//    func testing() {
//        print("back pressed")
//    }
    
    
}
