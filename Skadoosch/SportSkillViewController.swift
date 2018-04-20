//
//  SportSkillViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class SportSkillViewController: UIViewController, SportSkillLavelTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [[String: AnyObject]] = [[String: AnyObject]]()
    var expandedRows = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - Private

    func intialSetup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 63

        self.dataSource = [
            ["name": "SPORT" as AnyObject],
            ["name": "SPORT" as AnyObject],
            ["name": "SPORT" as AnyObject],
            ["name": "SPORT" as AnyObject],
            ["name": "SPORT" as AnyObject],
            ["name": "SPORT" as AnyObject]
        ]
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.sportSkillLavelTableViewCell, for: indexPath) as! SportSkillLavelTableViewCell
        cell.selectionStyle = .none
        let sport = self.dataSource[indexPath.row]
        cell.labelTitle.text = sport["name"] as? String
        cell.delegate = self
        cell.cellIndexPath = indexPath
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
    }
    
    // MARK: - SportSkillLavelTableViewCellDelegate
    
    func sportSkillLavelTableViewCellDidPressSwitch(value: Bool, indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! SportSkillLavelTableViewCell
        switch cell.isExpanded
            
        {
            
        case true:
            self.expandedRows.remove(indexPath.row)
            
        case false:
            self.expandedRows.insert(indexPath.row)
        }
        
        cell.isExpanded = !cell.isExpanded
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
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
