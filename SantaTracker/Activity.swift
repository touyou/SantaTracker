//
//  Activity.swift
//  SantaTracker
//
//  Created by 藤井陽介 on 2016/12/14.
//  Copyright © 2016年 touyou. All rights reserved.
//

import Foundation

enum Activity: Int {
    case unknown = 0
    case flying
    case deliveringPresents
    case tendingToReindeer
    case eatingCookies
    case callingMrsClaus
}

extension Activity: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown:
            return "❔ なにをしているか不明です..."
        case .callingMrsClaus:
            return "📞 奥さんと電話中です！"
        case .deliveringPresents:
            return "🎁 プレゼントを配っています！"
        case .eatingCookies:
            return "🍪 おやつをたべています。"
        case .flying:
            return "🚀 つぎの家まで移動中です。"
        case .tendingToReindeer:
            return "𐂂 トナカイのお世話をしています。"
        }
    }
}
