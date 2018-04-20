//
//  Utilities.swift
//  MoodChimp
//
//  Created by Jovan Jovanovic on 9/14/15.
//  Copyright (c) 2015 Borne. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import BRYXBanner
import EventKit

class Utilities {
    
    static let emailRegex = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"

    // Evalutation
    class func validateString(_ string: String, regex: String) -> Bool {
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }

    // MARK: - Alerts
    
    class func showUIAlertController(on viewController: UIViewController, message: String?) {
        guard let message = message, !message.isEmpty else {
            return
        }
        
        let applicationName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        let alertController = UIAlertController(title: applicationName, message: "\(message)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOk)
        if !(viewController.presentedViewController is UIAlertController) {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showBanner(title: String?, message: String?, image: UIImage?, backgroundColor: UIColor) {
        guard let message = message, !message.isEmpty else {
            return
        }
        
        let banner = Banner(title: title, subtitle: message, image: image, backgroundColor: backgroundColor)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    // MARK: - Useful Functions
    
    class func timeAgoSinceDate(_ date:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let unitFlags = NSCalendar.Unit.minute.union(NSCalendar.Unit.hour).union(NSCalendar.Unit.day).union(NSCalendar.Unit.weekOfYear).union(NSCalendar.Unit.month).union(NSCalendar.Unit.year).union(NSCalendar.Unit.second)
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components(unitFlags, from: earliest, to: latest, options: [])
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        }
        else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            }
            else {
                return "Last year"
            }
        }
        else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        }
        else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            }
            else {
                return "Last month"
            }
        }
        else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        }
        else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            }
            else {
                return "Last week"
            }
        }
        else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        }
        else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            }
            else {
                return "Yesterday"
            }
        }
        else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        }
        else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        }
        else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        }
        else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            }
            else {
                return "A minute ago"
            }
        }
        else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        }
        else {
            return "Just now"
        }
    }
    
    class func colorWithHexString (_ hex:String?) -> UIColor {
        if (hex == nil) {
            return UIColor.gray
        }
        
        var cString:String = hex!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    func base64StringFromString(_ string: String) -> String {
        let data : Data = (string as NSString).data(using: String.Encoding.utf8.rawValue)!
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    class func randRange(_ lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    // MARK: - UIImage
    
    class func imageResize(_ sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func rotateCameraImageToProperOrientation(_ imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.cgImage;
        
        let width = CGFloat((imgRef?.width)!);
        let height = CGFloat((imgRef?.height)!);
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat((imgRef?.width)!), height: CGFloat((imgRef?.height)!))
        
        
        switch(imageSource.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity
            
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height);
            transform = transform.rotated(by: CGFloat(M_PI));
            
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0);
            
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);
            
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);
            
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0);
            
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0);
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .right || orient == .left {
            context?.scaleBy(x: -scaleRatio, y: scaleRatio);
            context?.translateBy(x: -height, y: 0);
        } else {
            context?.scaleBy(x: scaleRatio, y: -scaleRatio);
            context?.translateBy(x: 0, y: -height);
        }
        
        context?.concatenate(transform);
        UIGraphicsGetCurrentContext()?.draw(imgRef!, in: CGRect(x: 0, y: 0, width: width, height: height));
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy!;
    }
    
    //MARK: - EkEvent
    
    class func ekEventToDictionary(_ ekEvent: EKEvent) -> [String: AnyObject] {
        
        return [
            "title" : ekEvent.title as AnyObject,
//            "location" : ekEvent.location as AnyObject,
//            "calendar" : ekEvent.calendar as AnyObject,
//            "alarms" : ekEvent.alarms as AnyObject,
//            "url" : ekEvent.url as AnyObject,
//            "lastModifiedDate" : ekEvent.lastModifiedDate as AnyObject,
            "startDate" : ekEvent.startDate as AnyObject,
            "endDate" : ekEvent.endDate as AnyObject
//            "isAllDay" : ekEvent.isAllDay as AnyObject,
//            "recurrenceRules" : ekEvent.recurrenceRules as AnyObject,
//            "attendees" : ekEvent.attendees as AnyObject
        ]
    }
    
    class func dictionaryToEkEvent(_ dictionary: [String: AnyObject]) -> EKEvent {
        let newEventStore = EKEventStore()
        let ekEvent = EKEvent(eventStore: newEventStore)
        
        ekEvent.title = dictionary["title"] as! String
//        ekEvent.location = dictionary["location"] as! String?
//        ekEvent.calendar = dictionary["calendar"] as! EKCalendar
//        ekEvent.alarms = dictionary["alarms"] as! [EKAlarm]?
//        ekEvent.url = dictionary["url"] as! URL?
        ekEvent.startDate = dictionary["startDate"] as! Date
        ekEvent.endDate = dictionary["endDate"] as! Date
//        ekEvent.isAllDay = dictionary["isAllDay"] as! Bool
//        ekEvent.recurrenceRules = dictionary["recurrenceRules"] as! [EKRecurrenceRule]?
        
        return ekEvent
    }
}
