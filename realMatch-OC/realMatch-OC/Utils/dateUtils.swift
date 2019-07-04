//
//  dateUtils.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/4.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class dateUtils: NSObject {
    static func dateConvertString(_ date:Date,dateFormat:String = "yyyy-MM-dd") -> String {
        let timeZone = TimeZone(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
}
