//
//  SubscriptionTableViewCell.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 4.9.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Static let
    
    static let cellID = "SubscriptionTableViewCell"

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public methods
    
    func setupData(title: String, description: String) {
        self.titleLabel.text = title.localized()
        self.descriptionLabel.text = description.localized()
    }

    
}
