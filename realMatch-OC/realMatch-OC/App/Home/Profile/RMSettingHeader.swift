//
//  RMSettingHeader.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/19.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMSettingHeader: UIView {
    
    var gradientLayer:CAGradientLayer
    var contentView:UIView
    
    override init(frame: CGRect) {
        self.gradientLayer = CAGradientLayer()
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.init(frame: frame)
        contentView = Bundle.main.loadNibNamed("RMSettingHeader", owner: self, options: nil)?.last as! UIView
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor(string: "ff009a").cgColor,UIColor(string: "00baff").cgColor]
        self.borderView.layer.borderColor = UIColor(string: "ffffff").cgColor
        self.borderView.layer.borderWidth = 1
        self.containerView.layer.insertSublayer(gradientLayer, at: 0)
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.containerView.bounds
        contentView.frame = self.bounds;
    }
    
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var containerView: UIView!
}
