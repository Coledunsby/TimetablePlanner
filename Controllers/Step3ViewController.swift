//
//  Step3ViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class Step3ViewController: UIViewController {
    
    @IBOutlet weak var leastGapsSwitch: UISwitch!
    @IBOutlet weak var mostDaysOffSwitch: UISwitch!
    @IBOutlet weak var noClassesOnMondaySwitch: UISwitch!
    @IBOutlet weak var noClassesOnTuesdaySwitch: UISwitch!
    @IBOutlet weak var noClassesOnWednesdaySwitch: UISwitch!
    @IBOutlet weak var noClassesOnThursdaySwitch: UISwitch!
    @IBOutlet weak var noClassesOnFridaySwitch: UISwitch!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leastGapsSwitch.on = GenerateManager.sharedManager.leastGaps
        mostDaysOffSwitch.on = GenerateManager.sharedManager.mostDaysOff
        noClassesOnMondaySwitch.on = GenerateManager.sharedManager.noClassesOnMonday
        noClassesOnTuesdaySwitch.on = GenerateManager.sharedManager.noClassesOnTuesday
        noClassesOnWednesdaySwitch.on = GenerateManager.sharedManager.noClassesOnWednesday
        noClassesOnThursdaySwitch.on = GenerateManager.sharedManager.noClassesOnThursday
        noClassesOnFridaySwitch.on = GenerateManager.sharedManager.noClassesOnFriday
    }
    
    // MARK: - IBActions
    
    @IBAction func leastGapsSwitchValueChanged(sender: UISwitch) {
        GenerateManager.sharedManager.leastGaps = sender.on
    }
    
    @IBAction func mostDaysOffSwitchValueChanged(sender: UISwitch) {
        GenerateManager.sharedManager.mostDaysOff = sender.on
    }
    
    @IBAction func noClassesOnMondaySwitchValueChanged(sender: UISwitch) {
        GenerateManager.sharedManager.noClassesOnMonday = sender.on
    }
    
    @IBAction func noClassesOnTuesdaySwitchValueChanged(sender: UISwitch) {
        GenerateManager.sharedManager.noClassesOnTuesday = sender.on
    }
    
    @IBAction func noClassesOnWednesdaySwitchValueChanged(sender: UISwitch) {
        GenerateManager.sharedManager.noClassesOnWednesday = sender.on
    }
    
    @IBAction func noClassesOnThursdaySwitchValueChanged(sender: UISwitch) {
        GenerateManager.sharedManager.noClassesOnThursday = sender.on
    }
    
    @IBAction func noClassesOnFridaySwitchValueChanged(sender: UISwitch) {
        GenerateManager.sharedManager.noClassesOnFriday = sender.on
    }
    
}
