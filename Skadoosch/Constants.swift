//
//  Constants.swift
//  MoodChimp
//
//  Created by Jovan Jovanovic on 9/14/15.
//  Copyright (c) 2015 Borne. All rights reserved.
//

import UIKit
import Foundation

struct Constants {
    
    enum UIUserInterfaceIdiom : Int {
        case unspecified
        case phone
        case pad
    }
    
    struct ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    }
    
    static func screenSizeConstant() -> CGFloat {
        if Constants.ScreenSize.SCREEN_HEIGHT == 568.0 {
            return 0.8
        }
        else if Constants.ScreenSize.SCREEN_HEIGHT == 480.0 {
            return 0.75
        }
        return 1.0
    }
    
    // Fonts
    struct appFont {
        struct monseratt {
            static let light = "Montserrat-Light"
            static let regular = "Montserrat-Regular"
            static let bold = "Montserrat-Bold"
            static let semiBold = "Montserrat-SemiBold"
            static let extraBold = "Montserrat-ExtraBold"
        }
    }
    
    // Notifications
    
    static let kSyncProcessDonenotification = "SyncProcessDonenotification"
    
    // Colors
    struct appColor {
        static let red = Utilities.colorWithHexString("E05D5D")
        static let green = Utilities.colorWithHexString("74F2B5")
        static let yellow = Utilities.colorWithHexString("E4B363")
        static let blueTransparent = UIColor(red: 83/256.0, green: 166/256.0, blue: 210/256.0, alpha: 0.8)
        
        struct gray {
            static let light = UIColor(white: 0.8374, alpha: 1.0)
            static let medium = Utilities.colorWithHexString("82828C")
            static let dark = Utilities.colorWithHexString("3B3B3B")
            static let segmentedGray = Utilities.colorWithHexString("FAFAFA")
            static let cellGray = Utilities.colorWithHexString("F9FAFB")
            static let separatorGray = Utilities.colorWithHexString("EAEAEA")
        }
        
        struct purple {
            static let dark = Utilities.colorWithHexString("9D6FB0")
            static let light = UIColor(red: 245/256.0, green: 240/256.0, blue: 247/256.0, alpha: 1.0)
        }
        
        struct black {
            static let dark = Utilities.colorWithHexString("1E1E28")
        }
        struct blue {
            static let dark = Utilities.colorWithHexString("415159")
        }
    }
    
    // Storyboards
    enum appStoryboard: String {
        case Login
        case Attend
        
        // Create an instance of UIStoryboard
        var instance: UIStoryboard {
            
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
        }
        
        // Function for Creating UIViewController in it's explicit Type from Storyboard
        func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
            
            let storyboardIdentifier = (viewControllerClass as UIViewController.Type).storyboardIdentifier
            guard let scene = instance.instantiateViewController(withIdentifier: storyboardIdentifier) as? T else {
                fatalError("ViewController with identifier \(storyboardIdentifier), not found in \(self.rawValue) Storyboard")
            }
            
            return scene
        }
        
        // Function for Creating initial View Controller from Storyboard
        func initialViewController() -> UIViewController? {
            
            return instance.instantiateInitialViewController()
        }
    }
    
    // Navigation Controllers
    enum appNavigationController: String {
        case loginNavigationController = "LoginNavigationController"

    }
    
    // View Controllers
    struct appViewController {
        static let pageViewController = "PageViewController"
    }
    
    struct appTabBarController {
        static let attendTabBarController = "AttendTabBarController"
    }
    
    // Views
    struct appViews {
        static let calendarHeaderView = "CalendarHeaderView"
        static let calendarEventView = "CalendarEventView"
        static let calendarCreateEventView = "CalendarCreateEventView"
    }
    
    // TableViewCells & CollectionViewCells
    struct appCells {
        struct attend {
            static let sportsTableViewCell = "SportsTableViewCell"
            static let radiusLocationTableViewCell = "RadiusLocationTableViewCell"
            static let costPerSessionTableViewCell = "CostPerSessionTableViewCell"
            static let profilePhotoTableViewCell = "ProfilePhotoTableViewCell"
            static let nameTableViewCell = "NameTableViewCell"
            static let aboutTableViewCell = "AboutTableViewCell"
            static let sportCategoryTableViewCell = "SportCategoryTableViewCell"
            static let sportSkillLavelTableViewCell = "SportSkillLavelTableViewCell"
            static let startEndTableViewCell = "StartEndTableViewCell"
            static let recurringDaysTableViewCell = "RecurringDaysTableViewCell"
            static let attendEventTableViewCell = "AttendEventTableViewCell"
            static let attendEventCollectionViewCell = "AttendEventCollectionViewCell"
        }
    }
    
    // Notifications
    struct appNotifications {
        static let contactsSelectedCreateEventNotification = "ContactsSelectedCreateEventNotification"

    }
    
    // Segues
    struct appSegues {
        static let onboardingViewControllerToWelcomeViewControllerSegue = "OnboardingViewControllerToWelcomeViewControllerSegue"
        static let welcomeViewControllerToEmailLoginViewControllerSegue = "WelcomeViewControllerToEmailLoginViewControllerSegue"
        static let welcomeViewControllerToCreateAccountViewControllerSegue = "WelcomeViewControllerToCreateAccountViewControllerSegue"
        static let emailLoginViewControllerToCreateAccountViewControllerSegue = "EmailLoginViewControllerToCreateAccountViewControllerSegue"
        static let createAccountViewControllerToTermsViewControllerSegue = "CreateAccountViewControllerToTermsViewControllerSegue"
        static let createAccountViewControllerToChooseHostOrAtendViewControllerSegue = "CreateAccountViewControllerToChooseHostOrAtendViewControllerSegue"
        static let chooseHostOrAtendViewControllerToAboutProfilesViewControllerSegue = "ChooseHostOrAtendViewControllerToAboutProfilesViewControllerSegue"
        static let chooseHostOrAtendViewControllerToSetUpAttendProfileViewControllerSegue = "ChooseHostOrAtendViewControllerToSetUpAttendProfileViewControllerSegue"
        static let setUpAttendProfileViewControllerToSportCategoriesViewControllerSegue = "SetUpAttendProfileViewControllerToSportCategoriesViewControllerSegue"
        static let sportCategoriesViewControllerToSportSkillViewControllerSegue = "SportCategoriesViewControllerToSportSkillViewControllerSegue"
        static let setUpAttendProfileViewControllerToAvailabilityViewControllerSegue = "SetUpAttendProfileViewControllerToAvailabilityViewControllerSegue"
    }
    
    // Table/Collection View Cells

}
