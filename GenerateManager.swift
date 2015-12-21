//
//  GenerateManager.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Foundation
import DateTools

class GenerateManager: NSObject {
    
    static let sharedManager = GenerateManager()
    
    var session: TPSession?
    var courses = [TPCourse]()
    
    var leastGaps = true
    var mostDaysOff = true
    var noClassesOnMonday = false
    var noClassesOnTuesday = false
    var noClassesOnWednesday = false
    var noClassesOnThursday = false
    var noClassesOnFriday = false
    
    private override init() {
        
    }
    
    func generateSchedulesInBackgroundWithBlock(block: ([TPTimetable], NSError?) -> Void) {
        getSectionsInBackgroundWithBlock { (sections, error) -> Void in
            var courseCombinations = [[[TPTimeslot]]]()
            
            for var i = 0; i < 8; i++ {
                courseCombinations.append([])
                if i < sections.count {
                    for section in sections[i].values {
                        courseCombinations[i].appendContentsOf(self.combinationsForSection(section))
                    }
                } else {
                    courseCombinations[i].append([])
                }
            }
            
            var combinationCount = 1
            
            for combination in courseCombinations {
                combinationCount *= combination.count
            }
            
            var combinations = [[Int]]()
            
            for var c1 = 0; c1 < courseCombinations[0].count; c1++ {
                for var c2 = 0; c2 < courseCombinations[1].count; c2++ {
                    for var c3 = 0; c3 < courseCombinations[2].count; c3++ {
                        for var c4 = 0; c4 < courseCombinations[3].count; c4++ {
                            for var c5 = 0; c5 < courseCombinations[4].count; c5++ {
                                for var c6 = 0; c6 < courseCombinations[5].count; c6++ {
                                    for var c7 = 0; c7 < courseCombinations[6].count; c7++ {
                                        for var c8 = 0; c8 < courseCombinations[7].count; c8++ {
                                            combinations.append([c1, c2, c3, c4, c5, c6, c7, c8])
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            var timetables = [TPTimetable]()
            
            for var i = 0; i < combinationCount; i++ {
                let combination = combinations[i]
                var timeslots = [TPTimeslot]()
                
                for var i = 0; i < self.courses.count; i++ {
                    timeslots.appendContentsOf(courseCombinations[i][combination[i]])
                }
                
                let timetable = TPTimetable()
                timetable.timeslots = timeslots
                timetables.append(timetable)
            }
            
            // Remove Invalid Schedules (conflicts)
            for timetable in timetables {
                if !self.timetableIsValid(timetable) {
                    timetables.removeObject(timetable)
                }
            }
            
            // Remove "no classes on"
            var noClassesOn = [self.noClassesOnMonday, self.noClassesOnTuesday, self.noClassesOnWednesday, self.noClassesOnThursday, self.noClassesOnFriday]
            
            for var i = 0; i < noClassesOn.count; i++ {
                if noClassesOn[i] {
                    for timetable in timetables {
                        if timetable.hasClassOn(i + 1) {
                            timetables.removeObject(timetable)
                        }
                    }
                }
            }
            
            // Sort
            if self.leastGaps && self.mostDaysOff {
                timetables = timetables.sort({ ($0.0.gaps == $0.1.gaps) ? $0.0.gaps < $0.1.gaps : $0.0.daysOff < $0.1.daysOff })
            } else if self.leastGaps {
                timetables = timetables.sort({ $0.0.gaps < $0.1.gaps })
            } else if self.mostDaysOff {
                timetables = timetables.sort({ $0.0.daysOff < $0.1.daysOff })
            }
            
            block(timetables, nil)
        }
    }
    
    private func getSectionsInBackgroundWithBlock(block: ([[String : TPSection]], NSError?) -> Void) {
        var sections = [[String : TPSection]]()
        var doneCount = 0
        
        for var i = 0; i < courses.count; i++ {
            var courseSections = [String : TPSection]()
            let course = courses[i]
            
            let query = TPTimeslot.query()!
            query.whereKey("sessionIdentifier", equalTo: session!.identifier!)
            query.whereKey("courseCode", equalTo: course.code!)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    for object in objects {
                        let timeslot = object as! TPTimeslot
                        
                        if let section = courseSections[timeslot.section!] {
                            section.timeslots.append(timeslot)
                        } else {
                            let section = TPSection()
                            section.course = course
                            section.name = timeslot.section
                            section.timeslots.append(timeslot)
                            
                            courseSections[timeslot.section!] = section
                        }
                    }
                }
                
                sections.append(courseSections)
                
                doneCount++
                
                if doneCount == self.courses.count {
                    block(sections, nil)
                }
            })
        }
    }
    
    private func combinationsForSection(section: TPSection) -> [[TPTimeslot]] {
        var combinations = [[TPTimeslot]]()
        let lectures = section.timeslots.filter({ $0.activity == "Lecture" || $0.activity == "Work" })
        let labs = section.timeslots.filter({ $0.activity == "Laboratory" })
        let dgds = section.timeslots.filter({ $0.activity == "Discussion" || $0.activity == "Tutorial" })
        
        if labs.count > 0 || dgds.count > 0 {
            var labDgdCombos = [[TPTimeslot]]()
            
            if labs.count == 0 {
                for dgd in dgds {
                    labDgdCombos.append([dgd])
                }
            } else if dgds.count == 0 {
                for lab in labs {
                    labDgdCombos.append([lab])
                }
            } else {
                for dgd in dgds {
                    for lab in labs {
                        labDgdCombos.append([lab, dgd])
                    }
                }
            }
            
            for combo in labDgdCombos {
                combinations.append(lectures + combo)
            }
        } else {
            combinations.append(lectures)
        }
        
        return combinations
    }
    
    private func timetableIsValid(timetable: TPTimetable) -> Bool {
        for timeslot in timetable.timeslots! {
            for otherTimeslot in timetable.timeslots! {
                if timeslot != otherTimeslot {
                    if timeslot.timePeriod.overlapsWith(otherTimeslot.timePeriod) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func reset() {
        session = nil
        courses.removeAll()
        
        leastGaps = true
        mostDaysOff = true
        noClassesOnMonday = false
        noClassesOnTuesday = false
        noClassesOnWednesday = false
        noClassesOnThursday = false
        noClassesOnFriday = false
    }
    
}
