//
//  Step1ViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class Step1ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var sessions = [TPSession]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GenerateManager.sharedManager.reset()
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        if let query = TPSession.query() {
            query.orderByAscending("name")
            query.limit = 1000
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    for object in objects {
                        self.sessions.append(object as! TPSession)
                    }
                    
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource
extension Step1ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let session = sessions[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = session.name
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a session:"
    }
    
}

// MARK: - UITableViewDelegate
extension Step1ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        GenerateManager.sharedManager.session = sessions[indexPath.row]
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
