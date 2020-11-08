//
//  BlueCloudCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 2/11/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class BlueCloudCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView! {
        didSet {
            imgView.contentMode = .scaleToFill
            imgView.layer.backgroundColor = UIColor.clear.cgColor
            
            imgView.layer.masksToBounds = false
            
           
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
