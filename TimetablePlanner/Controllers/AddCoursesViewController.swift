//
//  AddCoursesViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddCoursesViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private var courses = [TPCourse]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBarTextField = searchBar.valueForKey("searchField") as? UITextField
        searchBarTextField?.textColor = .whiteColor()
        searchBarTextField?.autocapitalizationType = .AllCharacters
        
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(sender: AnyObject?) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(courses.count, 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 && courses.count == 0 {
            let cellIdentifier = (searchBar.text?.trim().characters.count < 3) ? "CellEmpty" : "CellEmptySearch"
            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        } else {
            let course = courses[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = course.code
            cell.detailTextLabel?.text = course.name
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let course = courses[indexPath.row]
        courses.removeObject(course)
        
        GenerateManager.sharedManager.courses.append(course)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Text
        hud.labelText = "Added \(course.code!)!"
        hud.userInteractionEnabled = false
        hud.hide(true, afterDelay: 0.5)
        
        if GenerateManager.sharedManager.courses.count == 8 {
            doneButtonTapped(nil)
        }
    }
    
}

extension AddCoursesViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trim().characters.count >= 3 {
            if let query = TPCourse.query() {
                query.whereKey("sessions", equalTo: GenerateManager.sharedManager.session!.identifier!)
                query.whereKey("code", matchesRegex: searchText.trim(), modifiers: "i")
                query.whereKey("objectId", notContainedIn: GenerateManager.sharedManager.courses.map({ $0.objectId! }))
                query.orderByAscending("code")
                query.limit = 1000
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if let objects = objects {
                        self.courses.removeAll()
                        
                        for object in objects {
                            self.courses.append(object as! TPCourse)
                        }
                    
                        self.tableView.reloadData()
                    }
                })
            }
        } else {
            self.courses.removeAll()
            self.tableView.reloadData()
        }
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