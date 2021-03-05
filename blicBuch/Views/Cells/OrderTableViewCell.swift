//
//  OrderTableViewCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 8/22/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import RxSwift

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var sumPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    var disposeBag = DisposeBag()
    private var deviceType: DeviceType?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func styleViews(){
        self.deviceType = self.getDeviceType()
        self.sumLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.sumLabel.text = "Lieferung"
        self.sumPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.sumPriceLabel.text = "EUR 4,20"
        self.orderButton.layer.cornerRadius = 6
        self.orderButton.clipsToBounds = true
        self.orderButton.backgroundColor = deviceType != .macCatalyst ? Colors.blueDefault : .clear
        self.orderButton.tintColor = Colors.white
        self.orderButton.setTitle("Senden", for: .normal)
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }
    
}
