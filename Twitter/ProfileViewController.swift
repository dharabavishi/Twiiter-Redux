//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ruchit Mehta on 11/6/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit
import MBProgressHUD
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var userTimeline : [Tweet]!
    var user : User!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
      override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getUserTimeLineNew()

        // Do any additional setup after loading the view.
               
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if user == User.currentUser{
            
            backButton.isSelected = true
            
        }else{
             backButton.isSelected = false
        }
    }

    @IBAction func onBackClick(_ sender: UIButton) {
        
        if backButton.isSelected{
            NotificationCenter.default.postNotification(event: HamburgerEvent.ToggleMenu)
        }else{
            self.dismiss(animated: true, completion: {});

        }
        
        
    }
    func getUserTimeLineNew(){
        
        addHud()
        
        let strID = user.userID
        
        TwitterClient.sharedInstance.getUsertimeline(strID: strID,success: { (mentions : [Tweet]) in
            
            
            self.userTimeline = mentions
            self.tableView.reloadData()
            self.dismissHud()
            
        }) { (error : Error) in
            
            self.dismissHud()
            
        }

        
      
        
        
        

        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            if(self.userTimeline != nil){
                return userTimeline.count
            }else{
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! UserInfoCell
            
            cell.userInfo = user
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetsCell", for: indexPath) as! TweetsCell
                cell.profileImageView.isUserInteractionEnabled = true
                cell.tweet = self.userTimeline[indexPath.row]
           
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let bannerHeaderCell = tableView.dequeueReusableCell(withIdentifier: "BannerHeaderCell") as! BannerHeaderCell
            
            bannerHeaderCell.userInfo = user
            
            return bannerHeaderCell
        }
        
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return self.view.bounds.height * 0.25
        }
        return 0
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if indexPath.section == 0{
//            return 46
//        }
//        
//    }
    
    func setupTableView() {
       
        self.tableView.estimatedRowHeight = 250
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addHud(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    func dismissHud(){
        MBProgressHUD.hide(for: self.view, animated: true)
        
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
