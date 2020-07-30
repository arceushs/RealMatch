//
//  RMComplaintAPI.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/20.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMDeleteFileAPIData:NSObject{
    var code = 0;
    override init() {
        super.init()
    }
}

class RMDeleteFileAPI: NSObject, RMNetworkAPI{
    var uploadId:String
    init(uploadId:String){
        self.uploadId = uploadId
        super.init()
    }
    
    func parameters() -> [AnyHashable : Any]! {
        return ["uploadId":self.uploadId];
    }
    
    func requestHost() -> String! {
        return RMNetworkAPIHost.apiHost
    }
    
    func requestPath() -> String! {
        return "\(RMNetworkAPIHost.apiPath)/upload/delete"
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
            let data:RMDeleteFileAPIData = RMDeleteFileAPIData()
            data.code = dict["code"] as! Int
            return RMNetworkResponse(responseObject: data)
        }
        
        return response;
        
    }
}
