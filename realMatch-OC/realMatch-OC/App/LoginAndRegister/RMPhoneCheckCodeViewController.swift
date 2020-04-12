//
//  RMPhoneCheckCodeViewController.swift
//  realMatch-OC
//
//  Created by xulei on 2020/4/12.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit

class RMPhoneCheckCodeViewController: UIViewController, RouterController {
    required init!(routerParams params: [AnyHashable : Any]!) {
        self.phoneNum = params["phoneNum"] as? String
        self.phoneCountryCode = params["phoneCountryCode"] as? String
        super.init(nibName: nil, bundle: nil)
    }
    
    func displayStyle() -> DisplayStyle {
        return .push
    }
    
    func animation() -> Bool {
        return true
    }
    
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentCodeLabel = code1
        self.phoneNumberLabel.text = self.phoneNum
        
        self.smsCodeSender()
        // Do any additional setup after loading the view.
    }

    @IBAction func resend(_ sender: Any) {
    }
    
    @IBAction func `continue`(_ sender: Any) {
        let verifyCode = "\(self.code1.text)\(self.code2.text)\(self.code3.text)\(self.code4.text)\(self.code5.text)\(self.code6.text)"
        if verifyCode.count < 6 {
            self.codeCheckHintLabel.isHidden = false
            return
        }
        self.codeCheckHintLabel.isHidden = true
        
    }
    
    func smsCodeSender(){
        let phoneCheckAPI = RMPhoneCheckAPI(phone: self.phoneNum ?? "", phoneCountryCode: self.phoneCountryCode ?? "")
        RMNetworkManager.share()?.request(phoneCheckAPI, completion: { (response) in
            let data = response?.responseObject as? RMPhoneCheckAPIData
            if let data = data {
                if data.code == 200 {
                    
                } else {
                    SVProgressHUD.setStatus(data.message)
                }
            }
        })
    }
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var phoneNum: String?
    var phoneCountryCode: String?
    
    @IBOutlet weak var code1: UITextField!
    @IBOutlet weak var code2: UITextField!
    @IBOutlet weak var code3: UITextField!
    @IBOutlet weak var code4: UITextField!
    @IBOutlet weak var code5: UITextField!
    @IBOutlet weak var code6: UITextField!
    
    @IBAction func code1Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 0 {
            return
        }
        code2.becomeFirstResponder()
    }
    
    
    @IBAction func code2Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 0 {
            return
        }
        code3.becomeFirstResponder()
    }
    
    @IBAction func code3Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 0 {
            return
        }
        code4.becomeFirstResponder()
    }
    
    @IBAction func code4Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 0 {
            return
        }
        code5.becomeFirstResponder()
    }
    
    @IBAction func code5Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 0 {
            return
        }
        code6.becomeFirstResponder()
    }
    
    @IBAction func code6Edit(_ sender: Any) {
        code1.resignFirstResponder()
        code2.resignFirstResponder()
        code3.resignFirstResponder()
        code4.resignFirstResponder()
        code5.resignFirstResponder()
        code6.resignFirstResponder()
    }
    var currentCodeLabel:UITextField!
    
    @IBOutlet weak var codeCheckHintLabel: UILabel!
   
    

}
