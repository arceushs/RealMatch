//
//  RMAgreeView.swift
//  realMatch-OC
//
//  Created by xulei on 2020/2/9.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit

class RMAgreeTextView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var agreeLabel: TTTAttributedLabel!
    
    @IBOutlet weak var agreeButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("RMAgreeTextView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.frame = frame
        view.backgroundColor = UIColor(string: "000000", alpha: 0.8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
