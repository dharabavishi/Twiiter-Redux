//
//  BannerHeaderCell.swift
//  Twitter
//
//  Created by Ruchit Mehta on 11/6/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit

class BannerHeaderCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayLabel: UILabel!
    
    
    var userInfo:User! {
        
        didSet {
            if let profileBannerURL = userInfo.bannerImage {
                self.bannerImageView.setImageWith(profileBannerURL)
            }
            
            if let nameLabel = userInfo.name {
                self.nameLabel.text = nameLabel
            }
            if let screenLabel = userInfo.screenName {
                self.displayLabel.text = screenLabel
            }
            if let profileImageURL = userInfo.profileURL {
                self.profileImageView.setImageWith(profileImageURL)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.white.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
       

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
