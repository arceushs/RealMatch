//
//  RMPhoneCheckAPI.swift
//  realMatch-OC
//
//  Created by xulei on 2020/4/7.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit

class RMPhoneCheckAPIData: NSObject{
    var code: Int
    var message: String
    var data: String
    
    init(myData data:String, myCode code:Int, myMessage message:String) {
        self.data = data
        self.code = code
        self.message = message
        super.init()
    }
}

class RMPhoneCheckAPI: NSObject,RMNetworkAPI {
    
    var phone:String;
    var phoneCountryCode:String;
    
    init(phone:String, phoneCountryCode:String) {
        self.phone = phone
        self.phoneCountryCode = phoneCountryCode
        super.init()
    }
    
    func parameters() -> [AnyHashable : Any]! {
        return ["phone":self.phone,
                "phoneCountryCode":self.phoneCountryCode,
        ];
    }
    
    func requestHost() -> String! {
        return "https://www.4match.top"
    }
    
    func requestPath() -> String! {
        return "\(RMNetworkAPIHost.apiPath)/user/sms-code"
    }
    
    func method() -> RMHttpMethod {
        return .post
    }
    
    func taskType() -> RMTaskType {
        return .data
    }
    
    func adoptResponse(_ response: RMNetworkResponse<AnyObject>!) -> RMNetworkResponse<AnyObject>!{
        if response?.responseObject == nil {
            return RMNetworkResponse(error: response!.error)
        }
        if let dict = response.responseObject as? Dictionary<String,Any> {
            let phoneCheckAPIData = RMPhoneCheckAPIData(myData: "", myCode: 0, myMessage: "")
            phoneCheckAPIData.code = (dict["code"] as? Int) ?? 0
            phoneCheckAPIData.data = dict["data"] as? String ?? ""
            phoneCheckAPIData.message = dict["message"] as? String ?? ""
            return RMNetworkResponse(responseObject: phoneCheckAPIData)
        }
        return response;
    }

}
