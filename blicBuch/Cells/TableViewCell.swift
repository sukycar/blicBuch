//
//  TableViewCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var showTopLine:Bool = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var showAllLines:Bool = false{
        didSet{
            showBottomLine = showAllLines
            showTopLine = showAllLines
            showRightLine = showAllLines
            showLeftLine = showAllLines
        }
    }
    var showBottomLine:Bool = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var showLeftLine:Bool = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var showRightLine:Bool = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }

    
    class func calculateHeight(width:CGFloat, cell:UITableViewCell) -> CGFloat{
        let sizingCell = cell
        sizingCell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sizingCell.frame.size = CGSize(width: width, height: 0)
        var sizeToReturn = CGSize.zero
        sizeToReturn = sizingCell.contentView.systemLayoutSizeFitting(sizingCell.frame.size, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        return sizeToReturn.height
    }
    
    

    
    override func draw(_ rect: CGRect) {
        let bottomStartingPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomEndingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let topStartingPoint = CGPoint(x: rect.minX, y: rect.minY)
        let topEndingPoint = CGPoint(x: rect.maxX, y: rect.minY)
        
        let path = UIBezierPath()
        if showTopLine{
            path.move(to: topStartingPoint)
            path.addLine(to: topEndingPoint)
        }
        if showBottomLine{
            path.move(to: bottomStartingPoint)
            path.addLine(to: bottomEndingPoint)
        }
        if showRightLine{
            path.move(to: topEndingPoint)
            path.addLine(to: bottomEndingPoint)
        }
        if showLeftLine{
            path.move(to: topStartingPoint)
            path.addLine(to: bottomStartingPoint)
        }
        
        path.lineWidth = 1.0
        UIColor.lightGray.setStroke()
        
        path.stroke()
    }
}

