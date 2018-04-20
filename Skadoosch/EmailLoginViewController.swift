//
//  EmailLoginViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/19/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class EmailLoginViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func buttonSignIn(_ sender: UIButton) {
    }
    @IBAction func buttonCreateAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.appSegues.emailLoginViewControllerToCreateAccountViewControllerSegue, sender: self)
    }

}
