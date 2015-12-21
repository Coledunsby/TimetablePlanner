//
//  SettingsViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        TPUser.logOut()
        
        tabBarController?.selectedIndex = 0
        tabBarController!.performSegueWithIdentifier("ShowLogin", sender: self)
    }

}
