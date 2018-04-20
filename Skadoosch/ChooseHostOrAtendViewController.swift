//
//  ChooseHostOrAtendViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/19/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class ChooseHostOrAtendViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonAttend(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.appSegues.chooseHostOrAtendViewControllerToSetUpAttendProfileViewControllerSegue, sender: self)
    }
    @IBAction func buttonHost(_ sender: UIButton) {
    }
    @IBAction func buttonInfo(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.appSegues.chooseHostOrAtendViewControllerToAboutProfilesViewControllerSegue, sender: self)
    }
    

}
