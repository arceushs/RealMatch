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
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(resign))
        self.view.addGestureRecognizer(tapGest)
        // Do any additional setup after loading the view.
    }

    @objc func resign(){
        self.emailLabel.resignFirstResponder()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cotinueClicked(_ sender: Any) {
        if self.emailLabel.text?.contains("@") ?? false{
            self.hintLabel.isHidden = true
            self.lineView.backgroundColor = UIColor(string: "323640", alpha: 1)
            Router.shared()?.router(to: "RMNameViewController", parameter: nil)
        }else{
            self.hintLabel.isHidden = false
            self.lineView.backgroundColor = self.hintLabel.textColor
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
