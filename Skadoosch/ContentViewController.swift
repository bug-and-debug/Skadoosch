//
//  ContentViewController.swift
//  CatchApp
//
//  Created by Bosko Barac on 2/1/17.
//  Copyright © 2017 Borne. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var imageViewBackGround: UIImageView!
    @IBOutlet weak var imageViewFront: UIImageView!
    @IBOutlet weak var labelIntro: UILabel!
    
    var itemIndex: Int = 0
    var labelOneInfo: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup() {
        self.labelIntro.text = labelOneInfo
        
        if itemIndex == 0 {
            self.imageViewBackGround.image = UIImage(named: "OnboardingBackground1")
            self.imageViewFront.image = UIImage(named: "OnBoarding1")

        }
        else if itemIndex == 1 {
            self.imageViewBackGround.image = UIImage(named: "OnboardingBackground1")
            self.imageViewFront.image = UIImage(named: "OnBoarding1")
        }
        else {
            self.imageViewBackGround.image = UIImage(named: "OnboardingBackground2")
            self.imageViewFront.image = UIImage()
        }
    }
}
