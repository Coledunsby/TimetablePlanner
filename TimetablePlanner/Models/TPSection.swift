//
//  TPSection.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-21.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Foundation

class TPSection: NSObject {

    var course: TPCourse?
    var name: String?
    var timeslots = [TPTimeslot]()
    
}
