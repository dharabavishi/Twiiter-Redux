//
//  User.swift
//  Twitter
//
//  Created by Ruchit Mehta on 10/27/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userLogoutNotification = "UserLogout"
    var name : String?
    var screenName : String?
    var profileURL : URL?
    var tagline : String?
    var bannerImage : URL?
    var tweetCount:NSNumber!
    var userID : String
    
    var followersCount:NSNumber!
    var followingCount:NSNumber!
    var dictionary : NSDictionary?
    
    
    init (dictionary : NSDictionary){
        
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let urlString = profileUrlString{
            
            profileURL = URL(string : urlString)
        }
        let bannerUrlString = dictionary["profile_banner_url"] as? String
        if let urlString = bannerUrlString{
            
            bannerImage = URL(string : urlString)
        }
        userID = (dictionary["id_str"] as! String) as String

        tagline = dictionary["description"] as? String
        tweetCount = dictionary["statuses_count"] as! NSNumber
        followersCount = dictionary["followers_count"] as! NSNumber
        followingCount = dictionary["friends_count"] as! NSNumber
        
        
    }
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil  {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try!  JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey : "currentUser")
            } else {
                //defaults.set(nil, forKey : "currentUserData")
                defaults.removeObject(forKey: "currentUserData")
                
            }
            defaults.synchronize()
        }
    }
    

}
