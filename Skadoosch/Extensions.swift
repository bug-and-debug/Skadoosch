//
//  Extensions.swift
//  MyBio
//
//  Created by Jovan Jovanovic on 11/11/16.
//  Copyright © 2016 Borne Agency. All rights reserved.
//

import UIKit
import Foundation

extension UIWindow {
    
    // UIWindow extension for making a screenshot of the entire screen. Useful for blurry backgrounds.
    func captureImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardIdentifier: String {
        
        return "\(self)"
        // return String(reflecting: self).components(separatedBy: ".").last!
        // return "\(type(of:self))".components(separatedBy: ".").first!
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: Constants.appStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

extension UINavigationController {
    
    // Pull statusBarStyle value from visible View Controller
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if let rootViewController = self.viewControllers.last {
            return rootViewController.preferredStatusBarStyle
        }
        
        return super.preferredStatusBarStyle
    }
}

extension UIAlertController {
    
    // Helpful for adding multiple actions all the time
    func addActions(_ actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
}

//MARK : Array Extension

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    public mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}

extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
    
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}

//MARK : String Extensions

extension String {
    
    var length: Int { return self.characters.count }
    
    func initials() -> String {
        
        var arr = self.components(separatedBy: " ")
        
        if arr.count == 0 { return "" }
        
        return  arr[0].firstLetter() + arr[arr.count - 1].firstLetter()
    }
    
    func firstLetter() -> String {
        for c in self.characters {
            return "\(c)"
        }
        
        return ""
    }
}

extension String {
    func leftTrim(_ chars: Set<Character>) -> String {
        if let index = self.characters.index(where: {!chars.contains($0)}) {
            return self[index..<self.endIndex]
        } else {
            return ""
        }
    }
}

extension String {
    var stringByRemovingWhitespaceAndNewlineCharacterSet: String {
        return components(separatedBy: NSCharacterSet.whitespacesAndNewlines).joined(separator: "")
    }
}

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}

extension String {
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

// UIApplication Extensions

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

// MARK: Date Extensions

extension Date {
    
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension Date {
    var localTime: String {
        return description(with: NSLocale.current)
    }
}

extension Date {
    
    func differenceInDaysWithDate(date: Date) -> Int {
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([Calendar.Component.day], from: date1, to: date2)
        return components.day!
    }
}
