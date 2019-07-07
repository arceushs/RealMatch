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
    
    @objc static let shared:RMUserCenter = RMUserCenter()

}

