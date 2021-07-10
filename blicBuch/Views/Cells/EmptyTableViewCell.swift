//
//  EmptyTableViewCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.1.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import UIKit

class EmptyTableViewCell: TableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(_ title: String){
        self.titleLabel.text = title
        self.titleLabel.font = UIFont(name: FontName.regular.value, size: FontSize.label)
    }
}
