//
//  TimetablesViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class TimetablesViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private var timetables = [TPTimetable]()
    private var allTimetables = [TPTimetable]()

    // MARK: - View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if TPUser.currentUser() != nil {
            fetchData()
        }
        
        let searchBarTextField = searchBar.valueForKey("searchField") as? UITextField
        searchBarTextField?.textColor = .whiteColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        if let query = TPUser.currentUser()?.timetables?.query() {
            query.orderByAscending("name")
            query.limit = 1000
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    self.allTimetables.removeAll()
                    
                    for object in objects {
                        self.allTimetables.append(object as! TPTimetable)
                    }
                    
                    self.searchBar(self.searchBar, textDidChange: self.searchBar.text!)
                }
            })
        }
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetables.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let timetable = timetables[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = timetable.name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            timetables[indexPath.row].deleteInBackground()
            timetables.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let timetableVC = segue.destinationViewController as? TimetableViewController {
            timetableVC.timetable = timetables[tableView.indexPathForSelectedRow!.row]
        }
    }

}

// MARK: - UISearchBarDelegate
extension TimetablesViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trim() == "" {
            timetables = allTimetables
        } else {
            timetables = allTimetables.filter({ $0.name!.lowercaseString.containsString(searchText.trim().lowercaseString) })
        }

        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        var searchBarTextField: UITextField?
        
        for subview in searchBar.subviews[0].subviews {
            if subview.isKindOfClass(UITextField) {
                searchBarTextField = subview as? UITextField
                break
            }
        }
        
        searchBarTextField?.enablesReturnKeyAutomatically = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
