//
//  BlueCloudCellViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

class BlueCloudCellViewModel {
    
    var blueCloudCell = BlueCloudCellModel(imageName: "")
    
    init() {
        self.getImageName()
    }
    
    func getImageName(){
        self.blueCloudCell.imageName = BlueCloudCellData.imageName
    }
    
    func setImage() -> UIImage {
        var image = UIImage()
        let imageName = blueCloudCell.imageName
        image = UIImage(named: imageName) ?? UIImage()
        return image
    }
    
    func setImageViewProperties(for imageView: UIImageView?){
        guard let imageView = imageView else {return}
        imageView.layer.backgroundColor = UIColor.clear.cgColor
        imageView.layer.masksToBounds = false
    }
}
