//
//  TimetableViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class TimetableViewController: UIViewController {

    @IBOutlet weak var timetableView: TPTimetableView!
    
    var timetable: TPTimetable?
    
    // MARK: - View Lifeycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timetableView.timetable = timetable
    }
    
    // MARK: - IBActions
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        
    }

}
