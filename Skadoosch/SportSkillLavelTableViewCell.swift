//
//  SportSkillLavelTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

protocol SportSkillLavelTableViewCellDelegate {
    func sportSkillLavelTableViewCellDidPressSwitch(value: Bool, indexPath: IndexPath)
}

class SportSkillLavelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var switchSport: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var constraintHeightViewForSLider: NSLayoutConstraint!
    
    var delegate: SportSkillLavelTableViewCellDelegate?
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
                self.constraintHeightViewForSLider.constant = 0.0
                
            } else {
                self.constraintHeightViewForSLider.constant = 62
            }
        }
    }
    
    @IBAction func switchSport(_ sender: UISwitch) {
       self.delegate?.sportSkillLavelTableViewCellDidPressSwitch(value: sender.isOn, indexPath: cellIndexPath)
    }
    @IBAction func slider(_ sender: UISlider) {
    }

}
