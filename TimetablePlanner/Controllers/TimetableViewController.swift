//
//  TimetableViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimetableViewController: UIViewController {

    @IBOutlet weak var timetableView: TPTimetableView!
    
    var timetable: TPTimetable?
    
    // MARK: - View Lifeycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = timetable?.name
        
        timetableView.timetable = timetable
    }
    
    // MARK: - IBActions
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Rename", style: .Default, handler: { (action) -> Void in
            let renameController = UIAlertController(title: "Rename Timetable", message: "What do you want to call it?", preferredStyle: .Alert)
            
            renameController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            renameController.addAction(UIAlertAction(title: "Rename", style: .Default, handler: { (action) -> Void in
                let name = renameController.textFields![0].text?.trim()
                
                if name == "" {
                    self.presentViewController(UIAlertController.error("You need to enter a name."), animated: true, completion: nil)
                } else if name != self.timetable?.name {
                    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    
                    self.timetable?.name = name
                    self.timetable?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        
                        self.navigationItem.title = self.timetable?.name
                    })
                }
            }))
            
            renameController.addTextFieldWithConfigurationHandler { (textfield) -> Void in
                textfield.placeholder = "Enter a name"
                textfield.text = self.timetable?.name
            }
            
            self.presentViewController(renameController, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Share", style: .Default, handler: { (action) -> Void in
            let image = self.timetableView.createImage()
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            let deleteController = UIAlertController(title: "Are you sure?", message: "This operation cannot be undone.", preferredStyle: .Alert)
            
            deleteController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            deleteController.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                self.timetable?.deleteInBackgroundWithBlock({ (succeeded, error) -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                });
            }))
            
            self.presentViewController(deleteController, animated: true, completion: nil)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}
