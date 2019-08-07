//
//  RMMessageDetailModel.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/8/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objcMembers

@objc class RMMessageDetail: NSObject {
    var fromUser:String
    var toUser:String
    var msg:String
    var msgType:String
    var uploadId:Int
    var timestamp:Double
    
    init(_ dict:[String:Any]) {
        self.fromUser = "\((dict["fromUser"] as? Int) ?? 4029)"
        self.toUser = "\((dict["toUser"] as? Int) ?? 4031)"
        self.msg = (dict["msg"] as? String) ?? ""
        self.msgType = (dict["msg_type"] as? String) ?? ""
        self.uploadId = (dict["upload_id"] as? Int) ?? -1
        self.timestamp = 0
    }
}
