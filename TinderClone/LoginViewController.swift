//
//  LoginViewController.swift
//  TinderClone
//
//  Created by Connor Miller on 12/27/18.
//  Copyright © 2018 Connor Miller. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSignupBtn: UIButton!
    @IBOutlet weak var changeLoginSignupBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var isSignupMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if PFUser.current() != nil {

            if PFUser.current()?["isFemale"] != nil {

                self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)

            } else {

                self.performSegue(withIdentifier: "updateSegue", sender: nil)

            }

        }

    }

    @IBAction func loginSignup(_ sender: Any) {
        
        if isSignupMode {
            
            let user = PFUser()
            
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground { (success, error) in
                
                if error != nil {
                    
                    var errorMessage = "Sign Up Failed - Try Again"
                    
                    if let newError = error as NSError? {
                        
                        if let detailError = newError.userInfo["error"] as? String {
                            
                            errorMessage = detailError
                            
                        }
                        
                    }
                    
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                    
                } else {
                    
                    print("Sign up Successful")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                    
                }
                
            }
            
        } else {
            
            if let username = usernameTextField.text {
                
                if let password = passwordTextField.text {
                    
                    PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                        
                        if error != nil {
                            
                            var errorMessage = "Log In Failed - Try Again"
                            
                            if let newError = error as NSError? {
                                
                                if let detailError = newError.userInfo["error"] as? String {
                                    
                                    errorMessage = detailError
                                    
                                }
                                
                            }
                            
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                            
                        } else {
                            
                            print("Log In Successful")
                            
                            if user != nil {
                                
                                if user?["isFemale"] != nil {
                                    
                                    self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
                                    
                                } else {
                                    
                                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func changeLoginSignup(_ sender: Any) {
        
        if isSignupMode {
            
            loginSignupBtn.setTitle("Log In", for: .normal)
            changeLoginSignupBtn.setTitle("Sign Up", for: .normal)
            isSignupMode = false
            
        } else {
            
            loginSignupBtn.setTitle("Sign Up", for: .normal)
            changeLoginSignupBtn.setTitle("Log In", for: .normal)
            isSignupMode = true
            
        }
        
    }
}
