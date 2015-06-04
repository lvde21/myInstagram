//
//  TableViewController.swift
//  ParseStarterProject
//
//  Created by Lala Vaishno De on 6/3/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var usernames = [String]()
    var userids = [String]()
    var positions = [Int]()
    var isFollowing = [Bool]()
    
    
    // refresher
    var refresher : UIRefreshControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // implementing the refresher
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        refresh()
        
        
        // populating users list
//        var query = PFUser.query()
//        query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            
//            if let users = objects {
//                
//                // clearing the arrays
//                self.usernames.removeAll(keepCapacity: true)
//                self.userids.removeAll(keepCapacity: true)
//                
//                for object in users {
//                    
//                    if let user = object as? PFUser {
//                        if(user.objectId != PFUser.currentUser().objectId) {
//                        
//                            self.usernames.append(user.username!)
//                            self.userids.append(user.objectId!)
//                            
//                            // show the existing users you are following
//                            var query = PFQuery(className: "followers")
//                            query.whereKey("follower", equalTo : PFUser.currentUser().objectId!)
//                            query.whereKey("following", equalTo: user.objectId!)
//                            
//                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//                                
//                                //println(objects)
//                                // check to see if objects is not empty
//                                if let objects = objects as? [PFObject] {
//                                        
//                                    for object in objects {
//                                            
//                                        //if the current user is following the user that was read from parse
//                                            
//                                        var followingID: NSString = object["following"] as NSString
//                                        
//                                        var pos = find (self.userids, String(followingID))
//                                        
//                                        //println(pos!)
//                                        
//                                            if (pos >= 0) {
//                                                
//                                                self.positions.append(pos!)
//                                          
//                                            }
//                                        
//                                        
//                                    }
//                                } else {
//                                    println(error)
//                                }
//                                
//                                self.tableView.reloadData()
//                            })
//                        }
//                    }
//                }
//            }
//        }
    }
    
    
    
    // action for refresher
    func refresh() {
        
        //println("refreshed")
        
        // refreshing data from Parse
        
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let users = objects {
                
                // clearing the arrays
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.positions.removeAll(keepCapacity: true)
                
                println("positions = \(self.positions)")
                
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        if(user.objectId != PFUser.currentUser().objectId) {
                            
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            
                            // show the existing users you are following
                            var query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo : PFUser.currentUser().objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                println(objects)
                                // check to see if objects is not empty
                                if let objects = objects as? [PFObject] {
                                    
                                    for object in objects {
                                        
                                        //if the current user is following the user that was read from parse
                                        
                                        var followingID: NSString = object["following"] as NSString
                                        
                                        var pos = find (self.userids, String(followingID))
                                        
                                        println(pos!)
                                        
                                        if (pos >= 0) {
                                            
                                            self.positions.append(pos!)
                                            
                                        }
                                        
                                        
                                    }
                                } else {
                                    println(error)
                                }
                                
                                self.tableView.reloadData()
                                self.refresher.endRefreshing()
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    // sort the usernames along with the userids together
    func alphabeticalSort() {
        
        for (var i = 1; i < usernames.count; i++) {
            for(var j = i - 1; j >= 0; j--) {
                
                if(usernames[i] < usernames[j]) {
                    var temp : String = usernames[j]
                    usernames[j] = usernames[i]
                    usernames[i] = temp
                    
                    var temp2 : String = userids[j]
                    userids[j] = userids[i]
                    userids[i] = temp2
                    
                    i = 1
                }
                
            }
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        isFollowing.removeAll(keepCapacity: true)
        println("positions = + \(positions)")
        
        for(var j = 0; j < usernames.count; j++) {
            isFollowing.append(false)
        }
        //println("isFollowing 1 = \(isFollowing)")
        
        for(var i = 0; i < positions.count; i++) {
            if(positions[i] == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                isFollowing[indexPath.row] = true
            }
        }
        
        println("isFollowing 2 = \(isFollowing)")
        return cell
    }
    
    
    
    
    
    // MARK - adding features for following and followers
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("indexPath.row = \(indexPath.row)")
        
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if(isFollowing[indexPath.row] == false) {
        
            isFollowing[indexPath.row] = true
            
            
        
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
       
            var following = PFObject(className: "followers")
            following["following"] = userids[indexPath.row]
            following["follower"] = PFUser.currentUser().objectId
        
            following.saveInBackground()
        } else {
            
            isFollowing[indexPath.row] = false
             cell.accessoryType = UITableViewCellAccessoryType.None
            
            
            var query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo : PFUser.currentUser().objectId!)
            query.whereKey("following", equalTo: userids[indexPath.row])
            
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                // check to see if objects is not empty
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        
                        //if the current user is following the user that was read from parse
                        
                        var followingID: NSString = object["following"] as NSString
                        
                        var pos = find (self.userids, String(followingID))
                    
                        if (pos == indexPath.row) {
                            
                            object.deleteInBackground()
                            
                        }
                        
                        
                    }
                }
            })

            
            
        }
            
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
