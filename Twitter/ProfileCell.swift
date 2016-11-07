//
//  ProfileCell.swift
//  Twitter
//
//  Created by Ruchit Mehta on 11/3/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = 3
        profileImage.layer.masksToBounds = true
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
