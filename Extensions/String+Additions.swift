//
//  String+Additions.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-20.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Foundation

extension String {
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
}