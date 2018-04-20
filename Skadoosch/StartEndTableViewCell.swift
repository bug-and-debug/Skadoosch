//
//  StartEndTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

protocol StartEndTableViewCellDelegate {
    func startEndTableViewCellDelegateDidPickTime(time: String, indexPath: IndexPath)
}

class StartEndTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var constraintDatePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTimeDone: UILabel!
    @IBOutlet weak var labelStartEnd: UILabel!
    
    var delegate: StartEndTableViewCellDelegate?
    var cellIndexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.constraintDatePickerHeight.constant = 0.0
                
            } else {
                self.constraintDatePickerHeight.constant = 200
            }
        }
    }

    @IBAction func datePicker(_ sender: UIDatePicker) {
        
        let date = sender.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        self.delegate?.startEndTableViewCellDelegateDidPickTime(time: "\(hour):\(minute)", indexPath: self.cellIndexPath)
    }

}
