//
//  AttendEventsViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/25/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit
import XMSegmentedControl

class AttendEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMSegmentedControlDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    func initialSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 345
        
        segmentedControl.segmentTitle = ["EVENTS", "MAJOR EVENTS"]
        segmentedControl.selectedItemHighlightStyle = .background
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.highlightColor = UIColor.white
        segmentedControl.tint = Constants.appColor.gray.separatorGray
        segmentedControl.highlightTint = Constants.appColor.blue.dark
        segmentedControl.delegate = self
        //segmentedControl.font = UIFont(name: Constants.appFont..regular, size: 15)!
        self.view.addSubview(segmentedControl)
    }
    
    
    // MARK: - XMSegmentedControlDelegate
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 345
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.attendEventTableViewCell, for: indexPath) as! AttendEventTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


