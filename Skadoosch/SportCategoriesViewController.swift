//
//  SportCategoriesViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class SportCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var buttonDone: UIButton!
    
    var dataSource: [[String: AnyObject]] = [[String: AnyObject]]()

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
        self.tableVIew.dataSource = self
        self.tableVIew.delegate = self
        self.tableVIew.tableFooterView = UIView()
        
        self.dataSource = [
            ["name": "BALL SPORTS" as AnyObject],
            ["name": "COMBAT" as AnyObject],
            ["name": "CYCLING" as AnyObject],
            ["name": "DANCE" as AnyObject],
            ["name": "EXTREME" as AnyObject],
            ["name": "FITNESS" as AnyObject]
        ]
    }
    
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.sportCategoryTableViewCell, for: indexPath) as! SportCategoryTableViewCell
        
        let sport = self.dataSource[indexPath.row]
        cell.labelTitle.text = sport["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableVIew.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Constants.appSegues.sportCategoriesViewControllerToSportSkillViewControllerSegue, sender: self)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonDone(_ sender: UIButton) {
    }

}
