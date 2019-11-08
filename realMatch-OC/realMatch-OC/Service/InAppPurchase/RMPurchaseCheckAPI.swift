//
//  RMPurchaseCheckAPI.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/5.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

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
        return "/api/rechargeRecord"
    }
    
    func method() -> RMHttpMethod {
        return .post
    }
    
    func taskType() -> RMTaskType {
        return .data
    }
    
    
}
