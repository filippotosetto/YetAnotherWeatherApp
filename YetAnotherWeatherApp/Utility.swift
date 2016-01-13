//
//  Utility.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 28/07/2015.
//

import Foundation
import UIKit

typealias temperature = (date: NSDate, value: Double)
let apiKey = "271537219331766fbdaf30a4ef37fb33"


extension NSDate {
    
    convenience init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
    
    func getDayOfWeek()-> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale.autoupdatingCurrentLocale()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        return dateFormatter.stringFromDate(self)
    }
}

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}


extension UIView {
    
    // Position of the top-left corner in superview's coordinates
    var position: CGPoint {
        set {
            var rect = frame
            rect.origin = newValue
            frame = rect
        }
        
        get {
            return frame.origin
        }
    }
    
    var x: CGFloat {
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
        get {
            return frame.origin.y
        }
    }
    
    // Setting the size keeps the position (top-left corner) constant
    var size: CGSize {
        set {
            var rect = frame
            rect.size = newValue
            frame = rect
        }
        get {
            return frame.size
        }
    }
    
    var width: CGFloat {
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
        get {
            return frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
        get {
            return frame.size.height
        }
    }
    
    var right: CGFloat {
        set {
            x = newValue - width
        }
        get {
            return x + width
        }
    }
    
    var bottom: CGFloat {
        set {
            y = newValue - height
        }
        get {
            return y + height
        }
    }
}