//
//  TPTimeslot.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-11-17.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse
import DateTools

class TPTimeslot: PFObject, PFSubclassing {
    
    @NSManaged var sessionIdentifier: String?
    @NSManaged var courseCode: String?
    @NSManaged var section: String?
    @NSManaged var activity: String?
    @NSManaged var day: String?
    @NSManaged var professor: String?
    @NSManaged var place: String?
    
    static func parseClassName() -> String {
        return "Timeslot"
    }
    
    var timePeriod: DTTimePeriod {
        let parts = day?.componentsSeparatedByString(" ")
        
        if parts?.count == 4 {
            // Day
            var day = 0
            let weekday = parts![0]
            
            if weekday == "Monday" {
                day = 1
            } else if weekday == "Tuesday" {
                day = 2
            } else if weekday == "Wednesday" {
                day = 3
            } else if weekday == "Thursday" {
                day = 4
            } else if weekday == "Friday" {
                day = 5
            } else if weekday == "Saturday" {
                day = 6
            } else if weekday == "Sunday" {
                day = 7
            }
            
            // Start
            let startTime = parts![1]
            let startParts = startTime.componentsSeparatedByString(":")
            let startHour = Int(startParts[0])
            let startMinute = Int(startParts[1])
            
            // End
            let endTime = parts![3]
            let endParts = endTime.componentsSeparatedByString(":")
            let endHour = Int(endParts[0])
            let endMinute = Int(endParts[1])
            
            // Dates
            let startDate = NSDate(year: 1, month: 1, day: day, hour: startHour!, minute: startMinute!, second: 0)
            let endDate = NSDate(year: 1, month: 1, day: day, hour: endHour!, minute: endMinute!, second: 0)
            
            return DTTimePeriod(startDate: startDate, endDate: endDate)
        } else {
            return DTTimePeriod()
        }
    }
    
}
