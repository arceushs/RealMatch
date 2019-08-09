//
//  RMMessageParams.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/7.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
@objcMembers

@objc class RMMessageParams: NSObject {
    var fromUser:String
    var toUser:String
    var direction:String
    var count:Int
    var timestamp:Double
    
    init(_ dict:[String:Any]) {
        self.fromUser = (dict["fromUser"] as? String) ?? ""
        self.toUser = (dict["toUser"] as? String) ?? ""
        self.timestamp = (dict["timestamp"] as? Double) ?? 0
        self.direction = (dict["direction"] as? String) ?? ""
        self.count = (dict["count"] as? Int) ?? 0
    }
}
