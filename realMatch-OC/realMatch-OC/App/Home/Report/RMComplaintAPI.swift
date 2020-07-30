//
//  RMComplaintAPI.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/20.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMComplaintAPIData:NSObject{
    var code = 0;
    override init() {
        super.init()
    }
}

class RMComplaintAPI: NSObject, RMNetworkAPI{
    
    var content:String
    var complaintUser:String
    var complaintedUser:String
    init(content:String,complaintUser:String,complaintedUser:String){
        self.content = content
        self.complaintUser = complaintUser
        self.complaintedUser = complaintedUser
        super.init()
    }
    
    func parameters() -> [AnyHashable : Any]! {
        return ["content":self.content,
                "complaint_user":self.complaintUser,
                "complainted_user":self.complaintedUser,
        ];
    }
    
    func requestHost() -> String! {
        return RMNetworkAPIHost.apiHost
    }
    
    func requestPath() -> String! {
        return "\(RMNetworkAPIHost.apiPath)/complaint"
    }
    
    func method() -> RMHttpMethod {
        return .post
    }
    
    func taskType() -> RMTaskType {
        return .data
    }
    
    func adoptResponse(_ response: RMNetworkResponse<AnyObject>!) -> RMNetworkResponse<AnyObject>! {
        if response?.responseObject == nil {
            return RMNetworkResponse(error: response!.error)
        }
        
        if let dict = response.responseObject as? Dictionary<String,Any> {
            var data:RMComplaintAPIData = RMComplaintAPIData()
            data.code = dict["code"] as! Int
            return RMNetworkResponse(responseObject: data)
        }
        
        return response;
        
    }
}
