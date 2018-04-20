//
//  AvailabilityViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit
import FSCalendar

class AvailabilityViewController: UIViewController, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, StartEndTableViewCellDelegate {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var pickerDataSource: [[String: String]] = [[String: String]]()
    var expandedRows = Set<Int>()
    var datePicked: Bool = false
    var pickedCalendarDate = Date()
    var pickedStartTime = String()
    var pickedEndTime = String()
    var recurrintDaysDataSource: [[String: String]] = [[String: String]]()
    var recurringActivated: Bool = false

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ss.SSSSSS"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    func initialSetup() {
        self.calendarView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 43

        self.pickerDataSource = [
            ["name": "STARTING AT"],
            ["name": "ENDING AT"]
        ]
    }
    
    func setRecurringDaysDataSource(date: Date, startTime: String, endTime: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let stringFromDate = dateFormatter .string(from: date)
        self.recurringActivated = true

        switch stringFromDate {
        case "Monday":
            let monday = ["dayName" : "Mondays", "time" : "\(startTime) - \(endTime)"]
            if !self.recurrintDaysDataSource.contains{ $0 == monday } {
                self.recurrintDaysDataSource.append(monday)
            } else {
                print("doesn't contain dictionary")
            }
        case "Tuesday":
            let tuesday = ["dayName" : "Tuesdays", "time" : "\(startTime) - \(endTime)"]
            
            if !self.recurrintDaysDataSource.contains{ $0 == tuesday } {
                self.recurrintDaysDataSource.append(tuesday)
            } else {
                print("doesn't contain dictionary")
            }
            
        case "Wednesday":
            
            let wednesday = ["dayName" : "Wednesdays", "time" : "\(startTime) - \(endTime)"]
            
            if !self.recurrintDaysDataSource.contains{ $0 == wednesday } {
                self.recurrintDaysDataSource.append(wednesday)
            } else {
                print("doesn't contain dictionary")
            }
            
        case "Thursday":
            
            let thursday = ["dayName" : "Thursdays", "time" : "\(startTime) - \(endTime)"]
            
            if !self.recurrintDaysDataSource.contains{ $0 == thursday } {
                self.recurrintDaysDataSource.append(thursday)
            } else {
                print("doesn't contain dictionary")
            }
         
        case "Friday":
            
            let friday = ["dayName" : "Fridays", "time" : "\(startTime) - \(endTime)"]
            
            if !self.recurrintDaysDataSource.contains{ $0 == friday } {
                self.recurrintDaysDataSource.append(friday)
            } else {
                print("doesn't contain dictionary")
            }
            
        case "Saturday":
            
            let saturday = ["dayName" : "Saturdays", "time" : "\(startTime) - \(endTime)"]
            
            if !self.recurrintDaysDataSource.contains{ $0 == saturday } {
                self.recurrintDaysDataSource.append(saturday)
            } else {
                print("doesn't contain dictionary")
            }
        case "Sunday":
            
            let sunday = ["dayName" : "Sundays", "time" : "\(startTime) - \(endTime)"]
            
            if !self.recurrintDaysDataSource.contains{ $0 == sunday } {
                self.recurrintDaysDataSource.append(sunday)
            } else {
                print("doesn't contain dictionary")
            }
        default:
            self.recurrintDaysDataSource = [[:]]
        }
    }
    
    // MARK: - StartEndTableViewCellDelegate
    
    func startEndTableViewCellDelegateDidPickTime(time: String, indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.pickedStartTime = time
        }
        else {
            self.pickedEndTime = time
        }
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (datePicked) {
            return self.pickerDataSource.count
        }
        else if (recurringActivated) {
            return self.recurrintDaysDataSource.count
        }
         return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (datePicked) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.startEndTableViewCell, for: indexPath) as! StartEndTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.isExpanded = self.expandedRows.contains(indexPath.row)
            let startEnd = self.pickerDataSource[indexPath.row]
            cell.labelStartEnd.text = startEnd["name"]
            cell.labelTimeDone.text = ""
            cell.cellIndexPath = indexPath
            return cell
        }
        else if (recurringActivated) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.recurringDaysTableViewCell, for: indexPath) as! RecurringDaysTableViewCell
            cell.selectionStyle = .none
            let dayInfo = self.recurrintDaysDataSource[indexPath.row]
            cell.labelDay.text = dayInfo["dayName"]
            cell.labelTime.text = dayInfo["time"]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.startEndTableViewCell, for: indexPath) as! StartEndTableViewCell
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (datePicked) {
            let cell = self.tableView.cellForRow(at: indexPath) as! StartEndTableViewCell
            switch cell.isExpanded
                
            {
                
            case true:
                self.expandedRows.remove(indexPath.row)
                cell.labelTimeDone.textColor = Constants.appColor.blue.dark
                if indexPath.row == 1 {
                    cell.labelTimeDone.text = String(describing: self.pickedEndTime)
                    self.setRecurringDaysDataSource(date: self.pickedCalendarDate, startTime: self.pickedStartTime, endTime: self.pickedEndTime)
                    self.datePicked = false
                    self.tableView.reloadData()
                }
                else {
                    cell.labelTimeDone.text = String(describing: self.pickedStartTime)
                }
                
            case false:
                self.expandedRows.insert(indexPath.row)
                cell.labelTimeDone.text = "DONE"
                cell.labelTimeDone.textColor = Constants.appColor.green
            }
            
            cell.isExpanded = !cell.isExpanded
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    
    
    // MARK:- FSCalendarDelegate
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//    }
//    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
//        return monthPosition == .current
//    }
//    
//    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        return monthPosition == .current
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.pickedCalendarDate = date.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
        print("did select date \(self.formatter.string(from: date))")
        print("did select date2 \( self.pickedCalendarDate)")
        self.recurringActivated = false
        self.datePicked = true
        self.tableView.reloadData()
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        
        let unselectedDate = date.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let stringFromDate2 = dateFormatter.string(from: unselectedDate)
        
        var result = self.recurrintDaysDataSource
        //keep dicts only if their value for keyToRemove is nil (meaning key doesn't exist)
        for (index, dict) in result.enumerated() {
            if (dict["dayName"] == "\(stringFromDate2)s") {
                result.remove(at: index)
            }
        }
        self.recurrintDaysDataSource = result
        self.recurringActivated = true
        
        self.datePicked = false
        self.tableView.reloadData()
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
