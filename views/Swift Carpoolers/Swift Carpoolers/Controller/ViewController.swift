//
//  ViewController.swift
//  Swift Carpoolers
//
//  Created by Timmy Lee on 11/7/18.
//  Copyright © 2018 Hell on wheels. All rights reserved.
//

import UIKit
import UserNotifications

var userData : [String: Any] = [String: Any]()

class ViewController: UIViewController {
    // Registration
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var registerErrorLabel: UILabel!

    // Login
    @IBOutlet weak var emailAddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    // Preferences
    @IBOutlet weak var driver: UISegmentedControl!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var currentLocation: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var firstStop: UITextField!
    @IBOutlet weak var secondStop: UITextField!
    @IBOutlet weak var preferredTime: UIDatePicker!

    @IBAction func register(_ sender: Any) {
        let requestBody: [String: String] = [
            "user_id": username.text!,
            "first_name": firstName.text!,
            "last_name": lastName.text!,
            "password": password.text!,
            "phone_number": phoneNumber.text!,
            "gender": "placeholder"
        ]
//        let requestBody: [String: String] = [
//            "user_id": "hello3214ew2342@gmail.com",
//            "first_name": "test",
//            "last_name": "test",
//            "password": "test",
//            "phone_number": "777777777",
//            "gender": "placeholder"
//        ]

        userData["user_id"] = username.text!
        userData["first_name"] = firstName.text!
        userData["last_name"] = lastName.text!
        userData["password"] = password.text!
        userData["phone_number"] = phoneNumber.text!

        if (validateEmailAddress(email: username.text ?? "") && firstName.hasText && lastName.hasText && password.hasText) {
            registerErrorLabel.isHidden = true

            //api call
            let response = makeRequest("POST", "http://35.235.94.177:8000/users/reg/", requestBody)

            print(response)

            if let responseStatus = response["success"] as? Bool, responseStatus {
                performSegue(withIdentifier: "goToPreferencesSegue", sender: nil)
                print("Successful")
            } else {
                print("Unsuccessful")
            }

        } else {
            registerErrorLabel.isHidden = false
        }

    }

    @IBAction func LoginButton(_ sender: UIButton) {
        if(validateEmailAddress(email: emailAddressText.text ?? "") && passwordText.hasText){
            errorLabel.isHidden = true
            print(true)
        } else {
            errorLabel.isHidden = false
        }
    }

    @IBAction func savePreferences(_ sender: Any) {
        print("saving preferences")
        let requestBody: [String: Any] = [
            "type": driver.titleForSegment(at: driver.selectedSegmentIndex)! == "Share Ride" ? 0 : 1,
            "id": "20",
            "dest": destination.text!,
            "gender": gender.text!
        ]

        userData["type"] = requestBody["type"]
        userData["dest"] = requestBody["dest"]
        userData["gender"] = requestBody["gender"]
    }

    @IBAction func scheduleTime(_ sender: UIButton) {
        print("Inside scheduleTime")
        print(preferredTime.date)

        let requestBody: [String: Any?] = [
            "type": userData["type"],
            "id": 20,
            "dest": userData["dest"],
            "gender": userData["gender"],
            "time_window": preferredTime.date
        ]

        print(userData)

//        let response = makeRequest("POST", "http://35.235.94.177:8000/schedule/save.json", requestBody)

//        print(response)
    }

    func validateEmailAddress(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: email)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(errorLabel != nil){
           errorLabel.isHidden = true
        }

        if(registerErrorLabel != nil){
            registerErrorLabel.isHidden = true
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "unsuccessfulRegistration" {
                return false
            }
            return true
        }
        return true
    }

    func makeRequest(_ method: String, _ url: String, _ params: [String: Any?]) -> Dictionary<String, Any> {
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


    @IBAction func NotifyMeButton(_ sender: UIButton) {
//        let content = UNMutableNotificationContent()
//        content.title = "Weekly Staff Meeting"
//        content.body = "Every Tuesday at 2pm"
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (15), repeats: false)
//
//        // Create the request
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString,
//                                            content: content, trigger: trigger)
//
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.add(request) { (error) in
//            if error != nil {
//                // Handle any errors.
//            }
//
//    }
        var timer: Timer?
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [] _ in
            self.performSegue(withIdentifier: "bestMatchSegue", sender: nil)
            }
        }


}
