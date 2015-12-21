//
//  TPTimetableView.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-21.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework

class TPTimetableView: UIView {

    let colors = [FlatRed(), FlatGreen(), FlatBlue(), FlatOrange(), FlatYellowDark(), FlatTeal(), FlatWatermelon(), FlatPlum()]
    
    var setup = false
    
    private var _timetable: TPTimetable? = nil
    var timetable: TPTimetable? {
        get {
            return _timetable
        }
        set {
            _timetable = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !setup {
            draw()
            setup = true
        }
    }

    private func draw() {
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        var hour = 8
        var min = 0
        let rows = 31
        let cols = 6

        let height = bounds.size.height / CGFloat(rows)
        let timeWidth: CGFloat = 40
        let dayWidth = (bounds.size.width - timeWidth) / CGFloat(cols - 1)

        // Grid
        for var r = 0; r < rows; r++ {
            for var c = 0; c < cols; c++ {
                let x = (c <= 1) ? CGFloat(c) * timeWidth : timeWidth + (CGFloat(c - 1) * dayWidth)
                let width = (c == 0) ? timeWidth : dayWidth
                
                if r == 0 {
                    let label = UILabel(frame: CGRect(x: x, y: CGFloat(r) * height, width: width, height: height))
                    label.textAlignment = .Center
                    label.font = UIFont(name: "AvenirNext-Regular", size: 8)
                    label.layer.borderWidth = 0.5
                    
                    if c == 0 {
                        label.text = ""
                    } else if c == 1 {
                        label.text = "Monday"
                    } else if c == 2 {
                        label.text = "Tuesday"
                    } else if c == 3 {
                        label.text = "Wednesday"
                    } else if c == 4 {
                        label.text = "Thursday"
                    } else {
                        label.text = "Friday"
                    }
                    
                    addSubview(label)
                } else if c == 0 && r > 0 {
                    let label = UILabel(frame: CGRect(x: x, y: CGFloat(r) * height, width: width, height: height))
                    label.textAlignment = .Center
                    label.font = UIFont(name: "AvenirNext-Regular", size: 8)
                    label.layer.borderWidth = 0.5
                    label.text = String(format: "%02d:%02d", hour, min)                    
                    addSubview(label)
                    
                    min += 30
                    if min == 60 {
                        min = 0
                        hour++
                    }
                } else {
                    let view = UIView(frame: CGRect(x: x, y: CGFloat(r) * height, width: width, height: height))
                    view.layer.borderWidth = 0.5
                    addSubview(view)
                }
            }
        }
        
        PFObject.fetchAllIfNeededInBackground(timetable?.timeslots) { (objects, error) -> Void in
            if let objects = objects {
                let timeslots = objects as! [TPTimeslot]
                
                // Get courses (for colors)
                var courseCodes = [String]()
                for timeslot in timeslots {
                    if !courseCodes.contains(timeslot.courseCode!) {
                        courseCodes.append(timeslot.courseCode!)
                    }
                }
                
                // Add timeslots
                for timeslot in timeslots {
                    let timePeriod = timeslot.timePeriod
                    let startDate = timePeriod.StartDate
                    let endDate = timePeriod.EndDate
                    
                    let weekday = startDate.day()
                    let minutesAfter8 = startDate.minutesLaterThan(NSDate(year: startDate.year(), month: startDate.month(), day: startDate.day(), hour: 8, minute: 0, second: 0))
                    let durationMinutes = endDate.minutesLaterThan(startDate)
                    
                    let x = timeWidth + (CGFloat(weekday - 1) * dayWidth)
                    let y = height + (CGFloat(minutesAfter8 / 30) * height)
                    let h = CGFloat(durationMinutes) / CGFloat(30) * height
                    
                    let timeslotView = UIView(frame: CGRect(x: x, y: y, width: dayWidth, height: h))
                    timeslotView.backgroundColor = self.colors[courseCodes.indexOf(timeslot.courseCode!)!].colorWithAlphaComponent(0.9)
                    self.addSubview(timeslotView)
                    
                    var activity = timeslot.activity!.uppercaseString
                    if activity == "LECTURE" {
                        activity = "LEC"
                    } else if activity == "DISCUSSION" {
                        activity = "DGD"
                    } else if activity == "TUTORIAL" {
                        activity = "TUT"
                    } else if activity == "LABORATORY" {
                        activity = "LAB"
                    }
                    
                    let time = timeslot.day!.substringFromIndex(timeslot.day!.rangeOfString(" ")!.endIndex)
                    
                    let timeslotLabel = UILabel(frame: timeslotView.bounds)
                    timeslotLabel.font = UIFont(name: "AvenirNext-Medium", size: 8)
                    timeslotLabel.textColor = .whiteColor()
                    timeslotLabel.textAlignment = .Center
                    timeslotLabel.text = "\(timeslot.courseCode!)\(timeslot.section!) \(activity)\n\(time)"
                    
                    if timeslot.professor != "" {
                        timeslotLabel.text! += "\n\(timeslot.professor!)"
                    }
                    
                    timeslotLabel.numberOfLines = 0
                    timeslotView.addSubview(timeslotLabel)
                }
            }
        }
    }
    
}
