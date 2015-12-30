//
//  Step2ViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class Step2ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "ShowStep3" && GenerateManager.sharedManager.courses.count == 0 {
            presentViewController(UIAlertController.alert("Wait!", message: "You must select at least 1 course."), animated: true, completion: nil)
            return false
        } else if identifier == "AddCourse" && GenerateManager.sharedManager.courses.count == 8 {
            presentViewController(UIAlertController.alert("Limit Reached!", message: "You can only select up to 8 courses."), animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

// MARK: - UITableViewDataSource
extension Step2ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : GenerateManager.sharedManager.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath)
        } else {
            let course = GenerateManager.sharedManager.courses[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = course.code
            cell.detailTextLabel?.text = course.name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            GenerateManager.sharedManager.courses.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Select your courses:" : nil
    }

}

// MARK: - UITableViewDelegate
extension Step2ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 0
    }
    
}

