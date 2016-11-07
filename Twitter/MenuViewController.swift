//
//  MenuViewController.swift
//  Twitter
//
//  Created by Ruchit Mehta on 11/2/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    private var composeViewController : UIViewController!
    private var profileViewController : UIViewController!
    var viewControllers: [UIViewController] = []
    
    var hambugerViewController : HamburgerViewController!
    var tweetsViewController : UIViewController!
    let iconName : [UIImage] = [UIImage(named:"home")!,UIImage(named:"home")!,UIImage(named:"mentions")!,UIImage(named:"logout1")!]
    let iconTitle : [String] = ["","Home","Mentions","Logout"]
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        
        hambugerViewController = storyBoard.instantiateViewController(withIdentifier: "hamburgerViewController") as! HamburgerViewController
        profileViewController = storyBoard.instantiateViewController(withIdentifier: "profileViewController")
       
        tweetsViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        viewControllers.append(profileViewController)
        viewControllers.append(tweetsViewController)
        viewControllers.append(tweetsViewController)
        
        hambugerViewController.contentViewController = tweetsViewController
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            let user = User.currentUser!
            cell.profileImage.setImageWith((user.profileURL)!)
            cell.screenNameLabel.text = user.screenName
            cell.nameLabel.text = user.name
            cell.bannerImageView.setImageWith(user.bannerImage!)
            
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.iconImage.image = iconName[indexPath.row]
            cell.titleLabel.text = iconTitle[indexPath.row]
            return cell
        }
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if( indexPath.row == iconTitle.count-1){
            TwitterClient.sharedInstance.logout()
        }else{
            
            var currentVc : UIViewController
            
            currentVc = viewControllers[indexPath.row]
            if(currentVc is UINavigationController){
                currentVc = (currentVc as! UINavigationController).visibleViewController!
                if(currentVc  as? TweetViewController != nil){
                    print("tweet controller")
                    let tweetVc = currentVc as! TweetViewController
                    tweetVc.selectedMenu = indexPath.row
                }
            }
            if(currentVc  as? ProfileViewController != nil){
                
                let profileVC = currentVc as! ProfileViewController
                profileVC.user = User._currentUser
            }
            
            
            hambugerViewController.contentViewController = viewControllers[indexPath.row]
        }

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 130
        }else{
            return 44
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController
{
    enum typeOfMenuSelected:Int {
        case profile,tweets,mentions,logout
    }
}


