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
        let requestBody: [String: String] = [
            "username": username.text!,
            "firstName": firstName.text!,
            "lastName": lastName.text!,
            "password": password.text!,
            "phoneNumber": phoneNumber.text!
        ]
        
        makeRequest("POST", "https://ptsv2.com/t/32ki3-1541721566/post", requestBody)
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
    }
    
    func makeRequest(_ method: String, _ url: String, _ params: [String: String]) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method

        if (method != "GET") {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch let error {
                print(error)
                return
            }
        }
        let session = URLSession.shared
        
        session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print("error ")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                let responseJson = try JSONSerialization.jsonObject(with: responseData, options: [])
                guard let responseArray = responseJson as? [[String: Any]] else { return } // Assuming response is an array
                print(responseArray[0])
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
    }
    
    
}
