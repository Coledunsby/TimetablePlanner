//
//  TPUser.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-11-17.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

class TPUser: PFUser {
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var timetables: PFRelation?
    
}
