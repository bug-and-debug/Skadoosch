//
//  Settings.swift
//  MoodChimp
//
//  Created by Jovan Jovanovic on 9/14/15.
//  Copyright (c) 2015 Borne. All rights reserved.
//

import UIKit
import Foundation

class Settings {
    
    // Keys
    static let kLoginStatusKey: String = "LoginStatusKey"
    static let kAccessTokenKey: String = "AccessTokenKey"
    static let kFirstTimeTurnedOn: String = "FirstTimeTurnedOn"

    // MARK: - Login
    
    static func setUserLoggedIn(_ loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: kLoginStatusKey)
        UserDefaults.standard.synchronize()
    }
    
    static func userLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: kLoginStatusKey)
    }
 
    static func setFirstTimeTurnedOn(_ turnedOn: Bool) {
        UserDefaults.standard.set(turnedOn, forKey: kFirstTimeTurnedOn)
        UserDefaults.standard.synchronize()
    }
    
    static func firstTimeTurnedOn() -> Bool {
        return UserDefaults.standard.bool(forKey: kFirstTimeTurnedOn)
    }
    
    
    // MARK: - Access Token
    
    static func setAccessToken(_ accessTokenString: String) {
        UserDefaults.standard.set(accessTokenString, forKey: kAccessTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    static func accessToken() -> String? {
        if let accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
            return accessToken
        }
        
        return nil
    }
    
    // MARK: - User Details
}
