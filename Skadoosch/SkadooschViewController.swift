//
//  SkadooschViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/19/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class SkadooschViewController: UINavigationController {

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
        print("-----first view------");
        self.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.clear
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        if Constants.DeviceType.IS_IPHONE_5 {
//            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: Constants.appFont.monseratt.bold, size: 15)!]
//        }
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        
    }
    
    override var childViewControllerForStatusBarHidden : UIViewController? {
        return self.topViewController
    }
    
    override var childViewControllerForStatusBarStyle : UIViewController? {
        return self.topViewController
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .slide
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
