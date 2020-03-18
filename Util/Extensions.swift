//
//  Extensions.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}

extension Locale {
    public static let posix = Locale(identifier: "en_US_POSIX")
    public static func locale(forCountryName fullCountryName : String?) -> String {
        if fullCountryName != nil {
            for localeCode in NSLocale.isoCountryCodes {
                let identifier = NSLocale(localeIdentifier: localeCode)
                let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
                if fullCountryName?.lowercased() == countryName?.lowercased() {
                    return localeCode
                }
            }
        }
        return "en"
    }
}

extension Calendar {
    public static let posix: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .posix
        return calendar
    }()
}

extension Date {
    public static let reference = Calendar.posix.date(from: DateComponents(year: 2000))!
    
    public static func fromReferenceDays(days: Int) -> Date {
        Calendar.posix.date(byAdding: .day, value: days, to: Date.reference)!
    }
    
    public var referenceDays: Int {
        Calendar.posix.dateComponents([.day], from: Date.reference, to: self).day!
    }
    
    public var ageDays: Int {
        Calendar.posix.dateComponents([.day], from: self, to: Date()).day!
    }
    
    public var yesterday: Date {
        Calendar.posix.date(byAdding: .day, value: -1, to: self)!
    }
    
    public var relativeTimeString: String {
        if #available(iOS 13.0, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            return formatter.localizedString(for: self, relativeTo: Date())
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        var interval: Int
        var unit: String
        if let value = components.year, value > 0  {
            interval = value
            unit = "year"
        }
        else if let value = components.month, value > 0  {
            interval = value
            unit = "month"
        }
        else if let value = components.day, value > 0  {
            interval = value
            unit = "day"
        }
        else if let value = components.hour, value > 0  {
            interval = value
            unit = "hour"
        }
        else if let value = components.minute, value > 0  {
            interval = value
            unit = "minute"
        }
        else {
            return "moments ago"
        }
        
        return "\(interval) \(unit + (interval > 1 ? "s" : "")) ago"
    }
    
    public var relativeDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
}

extension TimeZone {
    public static let utc = TimeZone(identifier: "UTC")!
}

extension Double {
    public var kmFormatted: String {
        if self >= 10_000, self < 1_000_000 {
            return String(format: "%.1fk", locale: .posix, self / 1_000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self >= 1_000_000 {
            return String(format: "%.1fm", locale: .posix, self / 1_000_000).replacingOccurrences(of: ".0", with: "")
        }
        
        return NumberFormatter.groupingFormatter.string(from: NSNumber(value: self))!
    }
    
    public var percentFormatted: String {
        NumberFormatter.percentFormatter.string(from: NSNumber(value: self))!
    }
}

extension Int {
    public var kmFormatted: String { Double(self).kmFormatted }
}

extension NumberFormatter {
    public static let groupingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    public static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        return formatter
    }()
}

extension UIViewController {
    // see ObjectAssociation<T> class below
    private static let association = ObjectAssociation<UIActivityIndicatorView>()
    
    var indicator: UIActivityIndicatorView {
        set { UIViewController.association[self] = newValue }
        get {
            if let indicator = UIViewController.association[self] {
                return indicator
            } else {
                UIViewController.association[self] = UIActivityIndicatorView.customIndicator(at: self.view.center)
                return UIViewController.association[self]!
            }
        }
    }
    
    // MARK: - Acitivity Indicator
    public func startIndicatingActivity() {
        DispatchQueue.main.async {
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents() // if desired
        }
    }
    
    public func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

extension UIActivityIndicatorView {
    public static func customIndicator(at center: CGPoint) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        indicator.layer.cornerRadius = 10
        indicator.center = center
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.5)
        return indicator
    }
}

public final class ObjectAssociation<T: AnyObject> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ countryCode:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.isoCountryCode, $1) }
    }
}
