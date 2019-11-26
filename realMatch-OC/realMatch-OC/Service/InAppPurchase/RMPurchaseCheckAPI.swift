//
//  RMPurchaseCheckAPI.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/5.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objcMembers

class RMPurchaseCheckAPIData :NSObject {
    var recharged:Bool = false
}

@objcMembers
class RMPurchaseCheckAPI: NSObject,RMNetworkAPI {
    
    var receiptData:String
    var transactionId:String
    var productId:String
    var userId:String
    init(receiptData:String,transactionId:String,productId:String,userId:String) {
        self.receiptData = receiptData
        self.transactionId = transactionId
        self.productId = productId
        self.userId = userId
        super.init()
    }
    
    func parameters() -> [AnyHashable : Any]! {
        return ["receipt-data":self.receiptData,
                "transaction-id":self.transactionId,
                "product-id":self.productId,
                "userId":self.userId,
        ]
    }
    
    func requestHost() -> String! {
        return "https://www.4match.top"
    }
    
    func requestPath() -> String! {
        return "\(RMNetworkAPIHost.apiPath)/rechargeRecord"
    }
    
    func method() -> RMHttpMethod {
        return .post
    }
    
    func taskType() -> RMTaskType {
        return .data
    }
    
    func adoptResponse(_ response: RMNetworkResponse<AnyObject>!) -> RMNetworkResponse<AnyObject>! {
        if let responseObject = response.responseObject as? Dictionary<String,Any> {
            let dataDict = responseObject["data"] as? Dictionary<String,Any>
            if let dict = dataDict{
                let data = RMPurchaseCheckAPIData()
                data.recharged = dict["recharged"] as? Bool ?? false
                return RMNetworkResponse(responseObject: data)
            }
            
        }
        return RMNetworkResponse(responseObject: response.responseObject)
    }
    
}
