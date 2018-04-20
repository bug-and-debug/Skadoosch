//
//  SetUpAttendProfileViewController.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/20/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class SetUpAttendProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RadiusLocationTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonCreate: UIButton!
    
    var expandedRows = Set<Int>()
    var locationDataSource: [[String: AnyObject]] = [[String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    func initialSetup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 54
        
        self.locationDataSource = [
            ["name" : "LOCATION" as AnyObject],
            ["name" : "ADDITIONAL LOCATION (OPTIONAL)" as AnyObject]
        ]
        
        //self.tableView.allowsMultipleSelection = true
    }
    
    func openActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionsLibrary = UIAlertAction(title: "Choose from library", style: UIAlertActionStyle.default) { (alertAction) in
            // ImagePicker
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        let actionsCamera = UIAlertAction(title: "Take profile picture", style: UIAlertActionStyle.default) { (alertAction) in
            // ImagePicker
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        let actionsCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(actionsLibrary)
        alertController.addAction(actionsCamera)
        alertController.addAction(actionsCancel)
        
        if !(self.presentedViewController is UIAlertController) {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false) {
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - RadiusLocationTableViewCellDelegate
    
    func dadiusLocationTableViewCellDidChangeSliderValue(value: Float) {
        
    }

    // MARK: - UITableViewDelegate and UITableViewDataSource
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return self.locationDataSource.count
        }
        else {
          return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 54
//        }
//        else  if indexPath.row == 3 {
//            return 54
//        }
//        else {
//            
//        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 40
        }
        else {
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
////        if indexPath.row != 0 {
////            return 117
////        }
////        else {
////            return 54
////        }
//        return 54
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = Constants.appColor.gray.cellGray
        let viewBorderUp = UIView(frame: CGRect(x: 0, y: 39, width: tableView.frame.size.width, height: 1.0))
        viewBorderUp.backgroundColor = Constants.appColor.gray.separatorGray
        
        view.addSubview(viewBorderUp)

        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.sportsTableViewCell, for: indexPath) as! SportsTableViewCell
            cell.labelTitle.text = "SPORT & SKILL LEVEL"
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.radiusLocationTableViewCell, for: indexPath) as! RadiusLocationTableViewCell
            cell.selectionStyle = .none
            cell.isExpanded = self.expandedRows.contains(indexPath.row)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.costPerSessionTableViewCell, for: indexPath) as! CostPerSessionTableViewCell
            cell.selectionStyle = .none
            cell.isExpanded = self.expandedRows.contains(indexPath.row)
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.profilePhotoTableViewCell, for: indexPath) as! ProfilePhotoTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.nameTableViewCell, for: indexPath) as! NameTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.sportsTableViewCell, for: indexPath) as! SportsTableViewCell
            let option = self.locationDataSource[indexPath.row]
            cell.labelTitle.text = option["name"] as? String
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.appCells.attend.aboutTableViewCell, for: indexPath) as! AboutTableViewCell
            cell.selectionStyle = .none
            return cell
        }
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: Constants.appSegues.setUpAttendProfileViewControllerToSportCategoriesViewControllerSegue, sender: self)
        }
        else if indexPath.section == 1 {
            let cell = self.tableView.cellForRow(at: indexPath) as! RadiusLocationTableViewCell
            switch cell.isExpanded
                
            {
                
            case true:
                self.expandedRows.remove(indexPath.row)
                
            case false:
                self.expandedRows.insert(indexPath.row)
            }
            
            cell.isExpanded = !cell.isExpanded
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        else if indexPath.section == 2 {
            
            let cell = self.tableView.cellForRow(at: indexPath) as! CostPerSessionTableViewCell
            switch cell.isExpanded
                
            {
                
            case true:
                self.expandedRows.remove(indexPath.row)
                
            case false:
                self.expandedRows.insert(indexPath.row)
            }
            
            cell.isExpanded = !cell.isExpanded
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        else if indexPath.section == 3 {
            self.openActionSheet()
        }
    }
    
    
    

    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonSkip(_ sender: UIBarButtonItem) {
    }
    @IBAction func buttonCreate(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.appSegues.setUpAttendProfileViewControllerToAvailabilityViewControllerSegue, sender: self)
    }

}
