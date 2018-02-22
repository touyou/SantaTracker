//
//  Stop.swift
//  SantaTracker
//
//  Created by 藤井陽介 on 2016/12/14.
//  Copyright © 2016年 touyou. All rights reserved.
//

import Foundation
import RealmSwift

class Stop: Object {
    dynamic var location: Location?
    dynamic var time: Date = Date(timeIntervalSinceReferenceDate: 0)
    
    convenience init(location: Location, time: Date) {
        self.init()
        self.location = location
        self.time = time
    }
}
