//
//  TPTimetable.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-11-17.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

class TPTimetable: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var timeslots: [TPTimeslot]?
    
    static func parseClassName() -> String {
        return "Timetable"
    }
    
    var daysOff: Int {
        var daysOff = 0
        var days = [0,0,0,0,0,0,0]
        
        if let timeslots = timeslots {
            for timeslot in timeslots {
                let day = timeslot.timePeriod.StartDate.day() - 1
                days[day] += 1
            }
        }
        
        for day in days {
            if day == 0 {
                daysOff++
            }
        }
        
        return daysOff
    }
    
    var gaps: Int {
        var gaps = 0
        var days = [[TPTimeslot]](count: 7, repeatedValue: [])
        
        if let timeslots = timeslots {
            for timeslot in timeslots {
                let day = timeslot.timePeriod.StartDate.day() - 1
                if days[day].count == 0 {
                    days[day].append(timeslot)
                } else {
                    var added = false
                    for var i = 0; i < days[day].count && !added; i++ {
                        let otherTimeslot = days[day][i]
                        if timeslot.timePeriod.StartDate.isEarlierThan(otherTimeslot.timePeriod.StartDate) {
                            days[day].insert(timeslot, atIndex: i)
                            added = true
                        }
                    }
                    if !added {
                        days[day].append(timeslot)
                    }
                }
            }
        }
        
        for var i = 0; i < 7; i++ {
            let day = days[i]
            if day.count > 1 {
                for var j = 0; j < day.count - 1; j++ {
                    let timeslot = day[j]
                    let nextTimeslot = day[j + 1]
                    
                    if timeslot.timePeriod.EndDate.minutesEarlierThan(nextTimeslot.timePeriod.StartDate) > 0 {
                        gaps++
                    }
                }
            }
        }
        
        return gaps
    }
    
    func hasClassOn(day: Int) -> Bool {
        if let timeslots = timeslots {
            for timeslot in timeslots {
                if timeslot.timePeriod.StartDate.day() == day {
                    return true
                }
            }
        }
        return false
    }
    
}
