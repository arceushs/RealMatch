//
//  RMUserCenter.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/2.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objcMembers

class RMUserCenter: NSObject {
    var accountKitID:String?
    @objc var accountKitEmailAddress:String?
    @objc var accountKitPhoneNumber:String?
    @objc var accountKitCountryCode:String?
    
    var registerName:String?
    var registerEmail:String?
    var registerBirth:String?
    var registerSex:Int32?
    
    var userId:String?

    
    @objc static let shared:RMUserCenter = RMUserCenter()

}

