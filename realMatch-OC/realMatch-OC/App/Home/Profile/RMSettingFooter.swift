//
//  QTSettingFooter.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/19.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMSettingFooter: UIView {
    @IBOutlet weak var footerButton: UIButton!
    
    var buttonBlock:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var view = Bundle.main.loadNibNamed("RMSettingFooter", owner: self, options: nil)?.last as? UIView
        
        footerButton.layer.cornerRadius = 24
        footerButton.layer.borderColor = UIColor(string: "FA008E").cgColor
        footerButton.layer.borderWidth = 3

        view?.frame = frame
        if let view = view{
            self.addSubview(view)
        }
    }
    @IBAction func buttonClicked(_ sender: Any) {
        self.buttonBlock?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
  
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
