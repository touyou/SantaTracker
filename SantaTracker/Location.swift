//
//  Location.swift
//  SantaTracker
//
//  Created by 藤井陽介 on 2016/12/06.
//  Copyright © 2016年 touyou. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}
