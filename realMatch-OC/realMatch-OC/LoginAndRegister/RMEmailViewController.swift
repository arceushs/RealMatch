//
//  EmailViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/2.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objc class RMEmailViewController: UIViewController,RouterController {
    func animation() -> Bool {
        return true
    }
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var lineView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func displayStyle() -> DisplayStyle {
        return .push
    }
    
    required  init!(routerParams params: [AnyHashable : Any]!) {
        super.init(nibName: nil, bundle: nil)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hintLabel.isHidden = true
        // Do any additional setup after loading the view.
    }


    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cotinueClicked(_ sender: Any) {
        if self.emailLabel.text?.contains("@") ?? false{
            self.hintLabel.isHidden = true
            Router.shared()?.router(to: "RMNameViewController", parameter: nil)
        }else{
            self.hintLabel.isHidden = false
            self.lineView.backgroundColor = UIColor(red: 1.0, green: 0.56, blue: 0, alpha: 1)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
