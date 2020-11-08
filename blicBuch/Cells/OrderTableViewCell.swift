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
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var priceDetailsLabel: UILabel!
    @IBOutlet weak var transportPriceLabel: UILabel!
    @IBOutlet weak var sumPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    var disposeBag = DisposeBag()
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
        self.priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.priceLabel.text = "Gesamtmenge"
        self.transportLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.transportLabel.text = "Lieferung"
        self.sumLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.sumLabel.text = "Summe"
        self.priceDetailsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.priceDetailsLabel.text = "EUR 0,00"
        self.transportPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.transportPriceLabel.text = "EUR 4,20"
        self.sumPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.sumPriceLabel.text = "EUR 4,20"
        self.orderButton.layer.cornerRadius = 6
        self.orderButton.clipsToBounds = true
        self.orderButton.backgroundColor = Colors.blueDefault
        self.orderButton.tintColor = Colors.white
        self.orderButton.setTitle("Senden", for: .normal)
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }
    
}
