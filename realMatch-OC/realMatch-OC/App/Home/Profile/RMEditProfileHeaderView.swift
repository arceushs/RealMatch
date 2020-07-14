//
//  RMEditProfileHeaderView.swift
//  realMatch-OC
//
//  Created by xulei on 2020/5/24.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit

class RMEditProfileHeaderView: UIView {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var locationBottomLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var jobBottomLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var universityBottomLabel: UILabel!
    @IBOutlet weak var universityImageView: UIImageView!
    @IBOutlet weak var cameraIcon: UIButton!
    @IBOutlet weak var editIcon: UIButton!
    
    var  setBlock: (()->Void)?
    var  captureBlock :(()->Void)?
    
    @IBOutlet weak var isVip: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let headerView = Bundle.main.loadNibNamed("RMEditProfileHeaderView", owner: self, options: nil)?.last as? UIView
        headerView?.frame = frame;
        self.addSubview(headerView!)
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
        if let captureBlock = self.captureBlock {
            captureBlock()
        }
    }
    
    @IBAction func editClicked(_ sender: Any) {
        if let setBlock = self.setBlock {
            setBlock()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
