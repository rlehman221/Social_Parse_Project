
import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var users = [String: String]()
    var message = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                self.users.removeAll()
                
                for objects in users {
                    
                    if let user = objects as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                    }
                }
            }
            
            let getFollowedUserQuery = PFQuery(className: "Followers")
            
            getFollowedUserQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            
            getFollowedUserQuery.findObjectsInBackground(block: { (objects, error) in
                if let followers = objects {
                    
                    for object in followers {
                        
                        if let follower = object as? PFObject {
                            
                            let followerUser = follower["following"] as! String
                            
                            let query = PFQuery(className: "Posts")
                            
                            query.whereKey("userid", equalTo: followerUser)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let posts = objects {
                                    
                                    for object in posts {
                                        
                                        if let post = object as? PFObject {
                                            
                                            self.message.append(post["messages"] as! String)
                                            
                                            self.imageFiles.append(post["imagefile"] as! PFFile)
                                            
                                            
                                            self.usernames.append(self.users[post["userid"] as! String]!)
                                            
                                            
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            })
            
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return message.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell

        imageFiles[indexPath.row].getDataInBackground { (data, error) in
           
            
            if let imageData = data {
            
                if let downloadedImage = UIImage(data: imageData){
                
                    cell.postingImage1.image = downloadedImage
                }
            }
        }
        
        cell.postingImage1.image = UIImage(named: "msn-people-person-profile-user-icon--icon-search-engine-11.png")
        
        cell.usernameLabel.text = usernames[indexPath.row]
        
        cell.messageLabel.text = message[indexPath.row]
        
            
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
