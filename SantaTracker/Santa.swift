//
//  Santa.swift
//  SantaTracker
//
//  Created by 藤井陽介 on 2016/12/06.
//  Copyright © 2016年 touyou. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Santa: Object {
    private dynamic var _currentLocation: Location?
    var currentLocation: Location {
        get {
            return _currentLocation ?? Location(latitude: 90, longitude: 180)
        }
        set {
            _currentLocation = newValue
        }
    }
    
    let route = List<Stop>()
    
    private dynamic var _activity: Int = 0
    var activity: Activity {
        get {
            return Activity(rawValue: _activity)!
        }
        set {
            _activity = newValue.rawValue
        }
    }
    
    dynamic var presentsRemaining: Int = 0
    
    override static func ignoredProperties() -> [String] {
        return ["currentLocation", "activity"]
    }
    
    private var observerTokens = [NSObject: NotificationToken]()
    
    func addObserver(_ observer: NSObject) {
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation), options: .initial, context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.latitude), options: [], context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.longitude), options: [], context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa._activity), options: [], context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa.presentsRemaining), options: [], context: nil)
        
        observerTokens[observer] = route.addNotificationBlock {
            [unowned self, weak observer]  changes in
            switch changes {
            case .initial:
                observer?.observeValue(forKeyPath: "route", of: self, change: nil, context: nil)
            case .update:
                observer?.observeValue(forKeyPath: "route", of: self, change: nil, context: nil)
            case .error:
                fatalError("Couldn't update Santa's info")
            }
        }
    }
    
    func removeObserver(_ observer: NSObject) {
        observerTokens[observer]?.stop()
        observerTokens.removeValue(forKey: observer)
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation))
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.latitude))
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.longitude))
        removeObserver(observer, forKeyPath: #keyPath(Santa._activity))
        removeObserver(observer, forKeyPath: #keyPath(Santa.presentsRemaining))
    }
}

extension Santa {
    static func test() -> Santa {
        let santa = Santa()
        santa.currentLocation = Location(latitude: 37.7749, longitude: -122.4194)
        santa.activity = .deliveringPresents
        santa.presentsRemaining = 42
        return santa
    }
}
