//
//  WelcomeViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/19/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.white
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonFacebook(_ sender: UIButton) {
    }
    @IBAction func buttonTwitter(_ sender: UIButton) {
    }
    @IBAction func buttonSignUpEmail(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.appSegues.welcomeViewControllerToCreateAccountViewControllerSegue, sender: self)
    }
    @IBAction func buttonLogIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.appSegues.welcomeViewControllerToEmailLoginViewControllerSegue, sender: self)
    }

}
