//
//  LoginViewController.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 4/15/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameUITextField: UITextField!
    @IBOutlet weak var passwordUITextField: UITextField!
    @IBOutlet weak var loginUIButton: UIButton!
    @IBOutlet weak var signUpUIButton: UIButton!
    
    private var authenticationManager = AuthenticationManager.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnPressed(sender: AnyObject) {
        if (userNameUITextField.text == "" || passwordUITextField.text == "")
        {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please insert email and password."
            alert.addButtonWithTitle("Understod")
            alert.show()
        }
        else
        {
            authenticationManager.Login(userNameUITextField.text, pass: passwordUITextField.text)
        }
        
    }
    

}
