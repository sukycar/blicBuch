//
//  BlueCloudCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 2/11/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class BlueCloudCell: TableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    private let viewModel = BlueCloudCellViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleViews()
        self.selectionStyle = .none
    }
    
    func styleViews(){
        self.imgView.image = viewModel.setImage()
        self.viewModel.setImageViewProperties(for: imgView)
        self.titleLabel.text = "Write to us...".localized()
        self.bodyLabel.text = "Your suggestions and suggestions will be gladly accepted by us and they will challenge the readers' club".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
