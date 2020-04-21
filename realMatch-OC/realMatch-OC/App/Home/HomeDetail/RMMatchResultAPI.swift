//
//  RMMatchResultAPI.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/22.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
@objcMembers
class RMMatchResultAPIData :NSObject{
    var matched:Bool = false
}

@objcMembers
class RMMatchResultAPI: NSObject,RMNetworkAPI {
    func parameters() -> [AnyHashable : Any]! {
        return ["userId":self.userId,"type":self.type]
    }
    
    func requestHost() -> String! {
        return RMNetworkAPIHost.apiHost
    }
    
    func requestPath() -> String! {
        return "\(RMNetworkAPIHost.apiPath)/matchedusers"
    }
    
    func method() -> RMHttpMethod {
        return .get
    }
    
    func taskType() -> RMTaskType {
        return .data
    }
    
    var userId:String?
    var type:Int?
    
    init(userId:String,type:Int){
        self.userId = userId
        self.type = type
        super.init()
    }
    
    func adoptResponse(_ response: RMNetworkResponse<AnyObject>!) -> RMNetworkResponse<AnyObject>! {
        if response?.responseObject == nil {
            return RMNetworkResponse(error: response!.error)
        }
        if (response?.responseObject as! Dictionary<String,AnyObject>?) != nil{
            let dict = (response?.responseObject) as! Dictionary<String,AnyObject>
            let list = dict["list"] as? Array<Dictionary<String,Any>>
            if list?.count ?? 0 > 0{
                let data = RMMatchResultAPIData()
                data.matched = true
                return RMNetworkResponse(responseObject: data)
            }
        }
        return response;
    }
    
}
