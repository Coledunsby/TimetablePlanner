//
//  TPTableViewCell.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import ChameleonFramework

class TPTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgView = UIView(frame: frame)
        bgView.backgroundColor = FlatGreen().colorWithAlphaComponent(0.1)
        selectedBackgroundView = bgView
    }

}
