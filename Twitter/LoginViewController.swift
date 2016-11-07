//
//  LoginViewController.swift
//  Twitter
//
//  Created by Ruchit Mehta on 10/26/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
class LoginViewController: UIViewController {

    @IBOutlet weak var twitterIconImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIView.animate(withDuration: 0.6 ,
                                   animations: {
                                    self.twitterIconImage.transform = CGAffineTransform(scaleX: 4.5, y: 4.5)
        },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.6){
                                        self.twitterIconImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    }
        })
        
        
       
    }
    
    @IBAction func twitterLoginClick(_ sender: AnyObject) {
        
        TwitterClient.sharedInstance.login(success: {
            print("login is successful")
           
            
            self.performSegue(withIdentifier: "hamburgerSegue", sender: nil)
            
        }) { (error : Error) in
                print("login is not successful \(error.localizedDescription)")
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
       
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
