//
//  RadiusLocationTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/20/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

protocol RadiusLocationTableViewCellDelegate {
    func dadiusLocationTableViewCellDidChangeSliderValue(value: Float)
}

class RadiusLocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var constraintHeightViewForSlider: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var delegate : RadiusLocationTableViewCellDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.constraintHeightViewForSlider.constant = 0.0
                
            } else {
                self.constraintHeightViewForSlider.constant = 62
            }
        }
    }
    @IBAction func slider(_ sender: UISlider) {
        self.labelDistance.text = "\(slider.value) KM"
        self.delegate?.dadiusLocationTableViewCellDidChangeSliderValue(value: slider.value)
    }

}
