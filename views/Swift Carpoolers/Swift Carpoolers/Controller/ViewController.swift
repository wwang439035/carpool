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
        
        var url : String = "http://google.com?test=toto&test2=titi"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                // process jsonResult
            } else {
                // couldn't load JSON, look at error
            }
            
            
        })
        
        print(requestBody)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let vc = navigationController?.viewControllers.first
//        let button = UIBarButtonItem(barButtonSystemItem: "Go Back", target: self, action: testing)
//        vc?.navigationItem.backBarButtonItem = button
    }
    
//    func testing() {
//        print("back pressed")
//    }
    
    
}
