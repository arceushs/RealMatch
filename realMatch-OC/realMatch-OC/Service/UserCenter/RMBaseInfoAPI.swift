//
//  RMVipAPI.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/21.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
@objcMembers

class RMBaseInfoAPIData : NSObject{
    var userId:String=""
    var name:String?
    var email:String?
    var phone:String?
    var sex:Int?
    var age:Int?
    var area:String?
    var avatar:String?
    var recharged:Bool = false
    var isAnomaly:Bool = false
}

@objcMembers

class RMBaseInfoAPI: NSObject ,RMNetworkAPI{
    func parameters() -> [AnyHashable : Any]! {
        return nil
    }
    
    func requestHost() -> String! {
        return RMNetworkAPIHost.apiHost;
    }
    
    func requestPath() -> String! {
        return "\(RMNetworkAPIHost.apiPath)/\(self.userId)/baseInfo"
    }
    
    func method() -> RMHttpMethod {
        return .post
    }
    
    func taskType() -> RMTaskType {
        return .data
    }
    
    var userId:String=""
    
    init(userId:String){
        self.userId = userId;
        super.init()
    }
    
    func adoptResponse(_ response: RMNetworkResponse<AnyObject>!) -> RMNetworkResponse<AnyObject>! {
        if response?.responseObject == nil {
            return RMNetworkResponse(error: response!.error)
        }
        if let dict = response.responseObject as? Dictionary<String,Any> {
            let data:RMBaseInfoAPIData = RMBaseInfoAPIData()
            
            let dataDict = dict["data"]
            if let dataDict = dataDict as AnyObject?{
                data.userId = "\(dataDict["id"] as? Int ?? 0)"
                data.name = dataDict["name"] as? String ?? ""
                data.email = dataDict["email"] as? String ?? ""
                data.phone = dataDict["phone"] as? String ?? ""
                data.sex = dataDict["sex"] as? Int ?? 1
                data.age = dataDict["age"] as? Int ?? 26
                data.area = dataDict["area"] as? String ?? ""
                data.recharged = dataDict["recharged"] as? Bool ?? false
                data.isAnomaly = dataDict["is_anomaly"] as? Bool ?? false
            }
            return RMNetworkResponse(responseObject: data)
        }
        return response
        
    }
}
