//
//  PostImageViewController.swift
//  ParseStarterProject
//
//  Created by Lala Vaishno De on 6/4/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var message: UITextField!
    
    
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        println("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
    }
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        
        if(message.text == "" || imageToPost.image == UIImage(named: "photo-placeholder.gif")) {
            
            displayAlert("Don't leave things empty", message: "Image or Message not added")
            
        }
        
        else {
    
        // adding spinner
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        
        // uplaoading to Parse
        
        var post = PFObject(className: "Post")
        post["message"] = message.text!
        post["userid"] = PFUser.currentUser().objectId!
        
        
        let imageData = UIImagePNGRepresentation(imageToPost.image)
        let imageFile = PFFile(name: "image.png", data: imageData)
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if(error == nil) {
                
               //println("success")
                
                self.imageToPost.image = UIImage(named: "photo-placeholder.gif")
                
                self.message.text = ""
                
                self.displayAlert("Hooray !!!", message: "Image Posted Successfully")
                
                
            } else {
                
                
                self.displayAlert("Ooops !!!", message: "Error! Try again soon ok?")
                
            }
        
        }
        }
    }
    
    
    // MARK - generic display alert function
    
    func displayAlert(title : String, message : String) {
        
        var emptyFieldsAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        emptyFieldsAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(emptyFieldsAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
