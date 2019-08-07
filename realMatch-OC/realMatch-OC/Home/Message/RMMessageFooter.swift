//
//  RMMessageFooter.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/8/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objcMembers

@objc class RMMessageFooter: UIView {

    var footerView:UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.footerView = Bundle.main.loadNibNamed("RMMessageFooter", owner: nil, options: nil)?.last as? UIView
        self.addSubview(self.footerView!)
        self.footerView?.frame = self.bounds;
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
