//
//  TPProgressView.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

@IBDesignable
class TPProgressView: UIView {

    @IBInspectable var progressColor: UIColor = .blueColor()
    @IBInspectable var progress: CGFloat = 0.5

    override func drawRect(rect: CGRect) {
        progressColor.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: rect.width * progress, height: rect.height))
    }
    
}
