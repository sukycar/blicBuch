//
//  OrderTableViewCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 8/22/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import RxSwift

class OrderTableViewCell: TableViewCell {
    
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    var disposeBag = DisposeBag()
    private var deviceType: DeviceType?
    private var viewModel : OrderCellViewModel! {
        didSet {
            self.serviceTypeLabel.text = self.viewModel.serviceTypeText
            self.priceLabel.text = self.viewModel.priceText
            self.orderButton.setTitle(self.viewModel.orderButtonText, for: .normal)
            self.viewModel.configureButton(for: orderButton, deviceType: deviceType ?? .iPhone)
            self.serviceTypeLabel.font = viewModel.serviceTypeLabelFont
            self.priceLabel.font = viewModel.priceLabelFont
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.deviceType = self.getDeviceType()
        let cellModel = OrderCellModel(serviceText: OrderCellData.serviceText, priceText: OrderCellData.priceText, orderButtonText: OrderCellData.orderButtonText)
        viewModel = OrderCellViewModel(model: cellModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }
    
}
