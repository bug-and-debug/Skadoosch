//
//  NetworkController.swift
//  MoodChimp
//
//  Created by Jovan Jovanovic on 9/9/15.
//  Copyright (c) 2015 Borne. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

internal enum loginService: String {
    case facebook
    case twitter
    case linkedin
}
internal enum loginType: String {
    case user
    case employer
}

#if DEBUG
    fileprivate let host = "https://dev.new.catchappdata.co.uk/api/"
#else
    fileprivate let host = "https://dev.new.catchappdata.co.uk/api/"
#endif

fileprivate let kGenericErrorMessage = "Oops, something went wrong."

class NetworkController: NSObject {
    static let shared = NetworkController()
    
    var reachability: Reachability!
    private var sessionManager: Alamofire.SessionManager?
    private var authenticatedSessionManager: Alamofire.SessionManager?
    var currentReachabilityClosure: reachabilityClosure? {
        didSet {
            self.notifyCurrentReachabilityObserver()
        }
    }
    
    var refreshingToken = false
    
    internal typealias successClosure = (_ success: Bool) -> Void
    internal typealias responseClosure = (_ success: Bool, _ response: Any?) -> Void
    
    internal typealias sessionManagerClosure = (_ manager: Alamofire.SessionManager?, _ error: String?) -> Void
    internal typealias reachabilityClosure = (_ reachable: Bool, _ status: Reachability.NetworkStatus) -> Void
    
    override init() {
        super.init()
        
        // Setup Network Reachability
        self.reachability = Reachability()!
        NotificationCenter.default.addObserver(self, selector: #selector(NetworkController.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        NotificationCenter.default.addObserver(self, selector: #selector(NetworkController.applicationDidBecomeActiveNotification(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch {
            print("Reachabiliy Error: \(error)")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Reachability
    
    @objc private func reachabilityChanged(_ notification: Notification) {
        self.notifyCurrentReachabilityObserver()
    }
    
    @objc private func applicationDidBecomeActiveNotification(_ notification: Notification) {
        self.notifyCurrentReachabilityObserver()
    }
    
    internal func notifyCurrentReachabilityObserver() {
        if let closure = self.currentReachabilityClosure {
            closure(self.reachability.currentReachabilityStatus != Reachability.NetworkStatus.notReachable, self.reachability.currentReachabilityStatus)
        }
    }
    
    // MARK: - Auth
    
    fileprivate func alertUserThatLoginIsRequiredWithClosure(closure: @escaping responseClosure) {
        DispatchQueue.main.async { () -> Void in
            closure(false, "Login to continue." as AnyObject)
        }
    }
    
    // MARK: - Request
    
    func performRequest(authenticated: Bool, method: HTTPMethod, path: String, isFullPath: Bool, multipart: Bool, successCode: Int, parameters: [String: Any]?, additionalHeaders: [String: String]?,
                        closure: @escaping (_ success: Bool, _ response: Any?, _ statusCode: Int?, _ headers: [AnyHashable: Any]?) -> Void) {
        
        // Check for Internet Connection
        if (self.reachability.currentReachabilityStatus == Reachability.NetworkStatus.notReachable) {
            print("Internet not reachable with: \(path)")
            DispatchQueue.main.async { () -> Void in
                closure(false, "No Internet Connection", 0, nil)
            }
            return
        }
        
        // Prepare Headers
        var headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        if let additionalHeaders = additionalHeaders {
            for (key, value) in additionalHeaders {
                headers[key] = value
            }
        }
        if authenticated {
            if let token = Settings.accessToken() {
                headers["token"] = token
            }
            else {
                assertionFailure("Token failure with: \(path). Asking for authenticated request without a token.")
                return
            }
        }
        
        // Prepare Url
        let url = isFullPath ? path : host + path
        debugPrint("Performing Request: (\(method)) \(url) with parameters: \(parameters)")
        
        // Perform Request, Multipart or Standard
        if multipart {
            
            // Perform MultipartFormData Request
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if let parameters = parameters {
                    for (key, value) in parameters {
                        if value is Data {
                            multipartFormData.append(value as! Data, withName: key, fileName: "file.jpg", mimeType: "image/jpg")
                        }
                        else if value is String {
                            multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                        }
                    }
                }
            }, to: url, method: method, headers: headers, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    var success = false
                    var localResponse: Any?
                    var statusCode: Int? = 0
                    
                    // ---- Process Success ----
                    upload.validate().responseJSON(completionHandler: { (response) in
                        if response.result.isSuccess, response.response?.statusCode == successCode {
                            
                            // Success
                            success = true
                            localResponse = response.result.value
                            print("Success with: (\(method)) \(url) - \(response.data), \(response.result.value)")
                        }
                        else if ((response.response?.statusCode) != nil) {
                            
                            // API Error
                            localResponse = self.tryToGetErrorDescription(from: response.data as AnyObject)
                            print("Error with: (\(method)) \(url) - Data: \(response.data ?? Data()), JsonFromData: \(self.tryToGetErrorDescription(from: response.data as AnyObject) ?? ""), Error: \(response.result.error ?? nil), Status Code: \(response.response?.statusCode)")
                        }
                        else {
                            
                            // Networking Error
                            localResponse = self.tryToGetErrorDescription(from: response.result.error as AnyObject)
                            print("Error with: (\(method)) \(url) - Data: \(response.data ?? Data()), JsonFromData: \(self.tryToGetErrorDescription(from: response.data as AnyObject) ?? ""), Error: \(response.result.error ?? nil), Status Code: \(response.response?.statusCode)")
                        }
                        
                        // Respond
                        statusCode = response.response?.statusCode
                        DispatchQueue.main.async { () -> Void in
                            closure(success, localResponse, statusCode, response.response?.allHeaderFields)
                        }
                    })
                case .failure(let encodingError):
                    
                    // ---- Process Failure ----
                    print("Encoding Failure with: (\(method)) \(url) - \(encodingError)")
                    DispatchQueue.main.async { () -> Void in
                        closure(false, encodingError as AnyObject, 0, nil)
                    }
                }
            })
        }
        else {
            var encoding : ParameterEncoding = JSONEncoding.default
            if method == .get {
                encoding = URLEncoding.default
            }
            // Perform Request
            Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { (response) in
                var success = false
                var localResponse: Any?
                var statusCode: Int? = 0
                debugPrint(response)
                // Process Response
                if response.result.isSuccess, response.response?.statusCode == successCode {
                    
                    // Success
                    success = true
                    localResponse = response.result.value
                    print("Success with: (\(method)) \(url) - \(response.data), \(response.result.value)")
                }
                else if ((response.response?.statusCode) != nil) {
                    
                    // API Error
                    localResponse = self.tryToGetErrorDescription(from: response.data as AnyObject)
                    print("Error with: (\(method)) \(url) - Data: \(response.data ?? Data()), JsonFromData: \(self.tryToGetErrorDescription(from: response.data as AnyObject) ?? ""), Error: \(response.result.error ?? nil), Status Code: \(response.response?.statusCode)")
                }
                else {
                    
                    // Networking Error
                    localResponse = self.tryToGetErrorDescription(from: response.result.error as AnyObject)
                    print("Error with: (\(method)) \(url) - Data: \(response.data ?? Data()), JsonFromData: \(self.tryToGetErrorDescription(from: response.data as AnyObject) ?? ""), Error: \(response.result.error ?? nil), Status Code: \(response.response?.statusCode)")
                }
                
                // Respond
                statusCode = response.response?.statusCode
                DispatchQueue.main.async { () -> Void in
                    closure(success, localResponse, statusCode, response.response?.allHeaderFields)
                }
            }
        }
    }
    
    // MARK: - Error Validation
    
    fileprivate func tryToGetErrorDescription(from value: AnyObject?) -> String? {
        if let responseData = value as? Data {
            if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) {
                if let responseDictionary = json as? [AnyHashable: Any] {
                    for (key, value) in responseDictionary {
                        if key as? String == "error" {
                            return self.stringFromJsonObject(jsonObject: value)
                        }
                        else if key as? String == "revoked_reason" {
                            return self.stringFromJsonObject(jsonObject: value)
                        }
                    }
                }
                
                return "\(json)"
            }
        }
        else if let responseError = value as? Error {
            return responseError.localizedDescription
        }
        
        return kGenericErrorMessage
    }
    
    fileprivate func stringFromJsonObject(jsonObject: Any) -> String {
        if let string = jsonObject as? String {
            return string
        }
        else if let array = jsonObject as? [String], array.count > 0 {
            return array.first!
        }
        else if let array = jsonObject as? [AnyObject], array.count > 0 {
            return self.stringFromJsonObject(jsonObject: array)
        }
        else if let dictionary = jsonObject as? [String: AnyObject] {
            for (_, value) in dictionary {
                return self.stringFromJsonObject(jsonObject: value)
            }
        }
        
        return kGenericErrorMessage
    }
}
