//
//  Step4ViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD

class Step4ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var timetables = [TPTimetable]()
    var index = 0
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTimetables()
    }
    
    // MARK: - Private Functions
    
    private func generateTimetables() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Generating Timetables"
        
        GenerateManager.sharedManager.generateTimetablesInBackgroundWithBlock { (timetables, error) -> Void in
            hud.hide(true)
            
            self.timetables.appendContentsOf(timetables)
            
            self.statusLabel.hidden = false
            
            if self.timetables.count > 0 {
                self.statusLabel.text = "Timetable 1/\(self.timetables.count):"
                self.saveButton.hidden = false
                self.loadTimetables()
            } else {
                self.statusLabel.text = "No timetables found."
            }
        }
    }
    
    private func loadTimetables() {
        scrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(timetables.count), height: scrollView.frame.size.height)
        
        for var i = 0; i < timetables.count; i++ {
            let timetableView = TPTimetableView(frame: CGRect(x: view.frame.size.width * CGFloat(i) + 15, y: 0, width: view.frame.size.width - 30, height: scrollView.frame.size.height))
            timetableView.timetable = timetables[i]
            scrollView.addSubview(timetableView)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Save Timetable", message: "What do you want to call it?", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) -> Void in
            let name = alertController.textFields![0].text?.trim()
            
            if name == "" {
                self.presentViewController(UIAlertController.error("You need to enter a name."), animated: true, completion: nil)
            } else {
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                let timetable = self.timetables[self.index]
                timetable.name = name
                timetable.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    TPUser.currentUser()!.timetables?.addObject(timetable)
                    TPUser.currentUser()?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                        hud.mode = .Text
                        hud.labelText = "Saved!"
                        hud.userInteractionEnabled = false
                        hud.hide(true, afterDelay: 0.5)
                    })
                })
            }
        }))
        
        alertController.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "Enter a name"
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - UIScrollViewDelegate
extension Step4ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        index = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + CGFloat(1))
        statusLabel.text = "Timetable \(index + 1)/\(timetables.count):"
    }
    
}
