//
//  RMSettingTableViewCell.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/20.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMSettingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
