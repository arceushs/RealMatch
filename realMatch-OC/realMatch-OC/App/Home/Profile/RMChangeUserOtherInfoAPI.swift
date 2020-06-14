//
//  RMChangeUserOtherInfoAPI.swift
//  realMatch-OC
//
//  Created by arceushs on 2020/6/6.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit

class RMChangeUserOtherInfoAPIData: NSObject {
    var code:Int = 0
    var message:String = ""
}

class RMChangeUserOtherInfoAPI: NSObject,RMNetworkAPI {
    func parameters() -> [AnyHashable : Any]! {
        var userOtherInfo = ["school":self.school ?? "my school",
            "job":self.job ?? "my job",
            "about_me":self.aboutMe ?? "about me",
                ];
        if let avatar = self.avatar{
            userOtherInfo["avatar"] = avatar;
        }
        return userOtherInfo
    }
    
    convenience init(school:String?, job:String?, aboutMe:String?, avatar:String?) {
        
        self.init()
        self.school = school
        self.job = job
        self.aboutMe = aboutMe
        self.avatar = avatar
    }
    
    func requestHost() -> String! {
        return RMNetworkAPIHost.apiHost
    }
    
    func requestPath() -> String! {
        return "\(RMNetworkAPIHost.apiPath)/user/profile"
    }
    
    func method() -> RMHttpMethod {
        return .post
    }
    
    func taskType() -> RMTaskType {
        return .data
    }
    
    var school : String? = "my school"
    var job : String? = "my job"
    var aboutMe : String? = "about me"
    var avatar:String?
    
    func adoptResponse(_ response: RMNetworkResponse<AnyObject>!) -> RMNetworkResponse<AnyObject>! {
        if response?.responseObject == nil {
            return RMNetworkResponse(error: response.error)
        }
        if let dict = response.responseObject as? Dictionary<String,Any> {
            let data = RMChangeUserOtherInfoAPIData()
            data.code = dict["code"] as? Int ?? 0
            data.message = dict["message"] as? String ?? ""
            return RMNetworkResponse(responseObject: data)
        }
        return response
    }
}
