//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupActive = true

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var registeredText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    // MARK - generic display alert function
    
    func displayAlert(title : String, message : String) {
     
        var emptyFieldsAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        emptyFieldsAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(emptyFieldsAlert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        
        // check if username and password are not empty
        if(username.text == "" || password.text == "") {
            
            displayAlert("Error in Form", message: "Please enter a username and a password")
        
        } else {
            
            // sign up using Parse
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped  = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if(signupActive == true) {
            
                var user = PFUser()
                user.username = username.text
                user.password = password.text
            
                var errorMessage = "Please try again later"
            
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
               
                    if(error == nil) {
                        
                        // sign up succesful
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    
                    } else {
                    
                        if let errorString = error!.userInfo?["error"] as? String {
                        
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed Signup", message: errorMessage)
                    }
                })
            
            } else {
                
                //PFUser.logInWithUsernameInBackground(<#username: String!#>, password: <#String!#>, block: <#PFUserResultBlock!##(PFUser!, NSError!) -> Void#>)
                
                //login instead of signup
                PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if(user != nil) {
                        //use found
                        println("logged in")
                    } else {
                        if let errorString = error!.userInfo?["error"] as? String {
                            
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed Login", message: errorMessage)

                    }
                })
            }
        }
    }
        
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        if(signupActive == true) {
            
            signUpButton.setTitle("Login", forState: UIControlState.Normal)
            registeredText.text = "Not Registered?"
            loginButton.setTitle("Signup", forState: UIControlState.Normal)
            signupActive = false
        } else {
            
            signUpButton.setTitle("Signup", forState: UIControlState.Normal)
            registeredText.text = "Already Registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
        }
        
        
    }
    
    
    
    // view did load method runs before the segues are created
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // allows segues to run from start screen
    override func viewDidAppear(animated: Bool) {
        
        if(PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("login", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

