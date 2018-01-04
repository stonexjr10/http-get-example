//
//  ViewController.swift
//  HTTP-GET-example
//
//  Created by Sergey Kargopolov on 2016-01-01.
//  Copyright © 2016 Sergey Kargopolov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonTapped(_ sender: Any) {
        let userNameValue = userNameTextField.text
        
        if isStringEmpty(string: userNameValue!) == true
        {
            return
        }
        
        // Send HTTP GET Request 
  
        
//        let scriptUrl = "http://swiftdeveloperblog.com/my-http-get-example-script/"
        let scriptUrl = "https://prospero.uatproxy.cdlis.co.uk/prospero/DocumentUpload.ajax"
        let urlWithParams = scriptUrl + "?userName=\(userNameValue!)"
        let myUrl = URL(string: urlWithParams);
        
        if myUrl == nil {
            print("Invalid url: \"\(urlWithParams)\"")
            return
        }
        var request = URLRequest(url: myUrl!);
        request.httpMethod = "GET"

        // Add Basic Authorization
        /*
        let username = "myUserName"
        let password = "myPassword"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        */
        
        // Or add Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            print("\n\n")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    let statusCode = convertedJsonIntoDict["success"] as? NSNumber
                    print("statusCode=\(statusCode!)")
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()

        
    }
    
    func isStringEmpty(string stringValue: String) -> Bool
    {
        var stringValue = stringValue
        stringValue = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
    
        return stringValue.isEmpty
    }

}

