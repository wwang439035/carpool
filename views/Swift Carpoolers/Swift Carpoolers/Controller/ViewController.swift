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
//        let requestBody: [String: String] = [
//            "user_id": username.text!,
//            "first_name": firstName.text!,
//            "last_name": lastName.text!,
//            "password": password.text!,
//            "phone_number": phoneNumber.text!
//        ]
        
        let requestBody: [String: String] = [
            "user_id": "tilee212234@marketo.com",
            "first_name": "firstName.text!",
            "last_name": "lastName.text!",
            "password": "password.text!",
            "phone_number": "phoneNumber.text!",
            "gender": "placeholder"
        ]
        
        let response = makeRequest("POST", "http://35.235.94.177:8000/users/reg/", requestBody)
        
        print(response)
        
        if let responseStatus = response["success"] as? Bool, responseStatus {
            print("Successful")
        } else {
            print("Unsuccessful")
        }
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
    
    func makeRequest(_ method: String, _ url: String, _ params: [String: String]) -> Dictionary<String, Any> {
        var request = URLRequest(url: URL(string: url)!)
        let semaphore = DispatchSemaphore(value: 0)
        request.httpMethod = method

        if (method != "GET") {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
            } catch let error {
                return ["error": error]
            }
        }
        let session = URLSession.shared
        
        var responseDict : [String: Any] = [String: Any]()
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print("error ")
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return 
            }
            
            do {
//                print("Raw response = \(responseData)")
//                print(String(data: responseData, encoding: String.Encoding.utf8))
//                let httpReponse = responseData as? HTTPURLResponse
                let responseJson = try JSONSerialization.jsonObject(with: responseData, options: [])
                print(responseJson)
                guard let castedResponse = responseJson as? [String: Any] else { return }
//                guard let responseArray = responseJson as? [[String: Any]] else { return } // Assuming response is an array
                semaphore.signal()
                responseDict = castedResponse
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }

        task.resume()
        semaphore.wait()
        
        return responseDict
    }
    
    
}
