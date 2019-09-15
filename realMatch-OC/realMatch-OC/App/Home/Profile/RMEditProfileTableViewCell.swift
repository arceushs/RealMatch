//
//  RMEditProfileTableViewCell.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/19.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

enum EditCellType:NSInteger{
    case typeEdit
    case typeDelete
};

@objcMembers

@objc class RMEditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var editVideoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var addVideoView: UIView!
    
    var editButtonBlock:((_ cellType:EditCellType) ->Void)? = nil
    
    private var _cellType:EditCellType = .typeEdit
    var cellType:EditCellType{
        set{
            _cellType = newValue
            switch _cellType {
            case .typeEdit:
                self.editVideoButton.setImage(UIImage(named: "Edit_Video"), for: .normal)
            default:
                self.editVideoButton.setImage(UIImage(named: "Delete_Video"), for: .normal)
            }
        }
        get{
            return _cellType
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func editVideoButtonClicked(_ sender: Any) {
        guard let editButtonBlock = self.editButtonBlock  else {
            return
        }
        editButtonBlock(_cellType)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
