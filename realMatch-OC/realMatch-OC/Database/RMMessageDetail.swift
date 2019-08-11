//
//  RMMessageDetail.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/8/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objc enum MessageFrom:Int{
    case MessageFromOther
    case MessageFromMe
}

@objc class RMMessageDetail: NSObject {
    @objc var fromUser:String
    @objc var toUser:String
    private var _msg:String
    @objc var msg:String{
        get{
            return _msg
        }
        set{
            _msg = newValue
            let size = (_msg as NSString).boundingRect(with: CGSize(width: 181.0, height: 10000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], context: nil).size
            rowHeight = size.height + 26.0 + 8.0 + 8.0
        }
    }
    @objc var msgType:String
    @objc var uploadId:Int
    @objc var timestamp:Double
    
    
    @objc var messageFrom:MessageFrom
    @objc var rowHeight:CGFloat
    
    @objc init(_ dict:[String:Any]) {
        self.fromUser = (dict["fromUser"] as? String) ?? ""
        self.toUser = (dict["toUser"] as? String) ?? ""
        self._msg = (dict["msg"] as? String) ?? ""
        self.msgType = (dict["msg_type"] as? String) ?? ""
        self.uploadId = (dict["upload_id"] as? Int) ?? -1
        self.timestamp = 0
        self.messageFrom = .MessageFromMe
        self.rowHeight = 0;
        super.init()
        self.msg = _msg;
    }
}
