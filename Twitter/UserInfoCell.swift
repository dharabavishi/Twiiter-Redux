//
//  UserInfoCell.swift
//  Twitter
//
//  Created by Ruchit Mehta on 11/6/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!

    @IBOutlet weak var mainView: UIView!
    var userInfo:User! {
        
        didSet {
            self.tweetsCountLabel.text = userInfo.tweetCount.stringValue
            
            self.followersCountLabel.text = userInfo.followersCount.stringValue
            
            self.followingCountLabel.text = userInfo.followingCount.stringValue
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor.lightGray.cgColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
