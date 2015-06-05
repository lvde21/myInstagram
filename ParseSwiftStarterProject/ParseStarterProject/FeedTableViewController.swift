//
//  FeedTableViewController.swift
//  ParseStarterProject
//
//  Created by Lala Vaishno De on 6/5/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var messages = [String]()
    var usernames = [String]()
    var images = [PFFile]()
    
    // dictionary relating userids to usernames
    var users = [String : String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // filling users array
        
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            
            //to check if objects is not empty
            if let users = objects {
                
                //clearing the arrays
                self.messages.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.images.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                
                
                for user in users {
                    
                    if let user = user as? PFUser {
                        
                        //adding user ids into users dictionary
                        self.users[user.objectId!] = user.username!
                    }
                }
            }
        }
        
        println(users)
        
        
        
        var getFollowedUsersQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().objectId)
        
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    var followedUser = object["following"] as String
                    
                    
                    // download images of followedUser
                    
                    var query = PFQuery(className: "Post")
                    query.whereKey("userid", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if let objects = objects {
                            
                            for object in objects {
                                
                                self.messages.append(object["message"] as String)
                                self.images.append(object["imageFile"] as PFFile)
                                self.usernames.append(self.users[object["userid"] as String]!)
                                
                                self.tableView.reloadData()
                            }
                            
                            println(self.users)
                            println(self.messages)
                        }
                    })
                    
                    
                    
                }
                
            }
        }
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //using custom class cell.swift to create custom cells. *****
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as cell
        
        
        //downloading image files from Parse
        images[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data) {
                
                myCell.postedImage.image = downloadedImage
            } else {
                
                myCell.postedImage.image = UIImage(named: "photo-placeholder.gif")
            }
            
        }
        
        
        
        myCell.username.text = usernames[indexPath.row]
        myCell.message.text = messages[indexPath.row]

        return myCell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
