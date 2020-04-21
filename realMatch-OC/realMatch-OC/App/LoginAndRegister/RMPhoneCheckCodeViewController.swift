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
        let index = self.phoneCountryCode?.startIndex
        self.phoneCountryCode?.remove(at: (index)!)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @objc func timeCount(){
        if RMUserCenter.shared.countTime <= 0{
            self.resendButton.isEnabled = true
            self.resendLabel.text = "Resend"
            return
        }
        self.resendButton.isEnabled = false
        RMUserCenter.shared.countTime = RMUserCenter.shared.countTime - 1
        self.resendLabel.text = "\(RMUserCenter.shared.countTime)s"
        self.perform(#selector(timeCount), with: nil, afterDelay: 1)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resend(_ sender: Any) {
        self.smsCodeSender()
    }
    
    deinit {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var resendLabel: UILabel!
    @IBAction func `continue`(_ sender: Any) {
        let verifyCode = "\(self.code1.text ?? "")\(self.code2.text ?? "")\(self.code3.text ?? "")\(self.code4.text ?? "")\(self.code5.text ?? "")\(self.code6.text ?? "")"
        if verifyCode.count < 6 {
            self.codeCheckHintLabel.isHidden = false
            return
        }
        self.codeCheckHintLabel.isHidden = true
        SVProgressHUD.show()
        RMUserCenter.shared.accountKitCountryCode = self.phoneCountryCode
        RMUserCenter.shared.accountKitPhoneNumber = self.phoneNum
        let loginAPI = RMLoginAPI(phone: self.phoneNum!, phoneCountryCode: self.phoneCountryCode!, smsCode: verifyCode)
        
        RMNetworkManager.share()?.request(loginAPI, completion: { (response) in
            SVProgressHUD.dismiss()
            if let data = response?.responseObject as? RMLoginAPIData{
                if data.code != 200 {
                    SVProgressHUD.showError(withStatus: data.msg)
                    return
                }
                if data.appToken.count > 0 {
                    UserDefaults.standard.set(data.appToken, forKey: "global-token");
                }
                RMUserCenter.shared.userId = data.userId
                if data.userId.count > 0 {
                    UserDefaults.standard.set(data.userId, forKey: "global-userId");
                }
                UserDefaults.standard.synchronize()
//                if(!data.newUser){
//                    Router.shared()?.router(to: "RMHomePageViewController", parameter: nil)
//                }else{
                    Router.shared()?.router(to: "RMNameViewController", parameter: nil)
//                }
            }
            
        });
    }
    
    func smsCodeSender(){
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if RMUserCenter.shared.countTime <= 0{
            RMUserCenter.shared.countTime = 60
            self.timeCount()
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
        } else {
            self.timeCount()
            self.resendButton.isEnabled = false
        }
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
        if (sender as! UITextField).text?.count ?? 0 > 1 {
            (sender as! UITextField).text = String(((sender as! UITextField).text?.last)!)
        }
        code2.becomeFirstResponder()
    }
    
    
    @IBAction func code2Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 1 {
            (sender as! UITextField).text = String(((sender as! UITextField).text?.last)!)
        }
        code3.becomeFirstResponder()
    }
    
    @IBAction func code3Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 1 {
            (sender as! UITextField).text = String(((sender as! UITextField).text?.last)!)
        }
        code4.becomeFirstResponder()
    }
    
    @IBAction func code4Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 1 {
            (sender as! UITextField).text = String(((sender as! UITextField).text?.last)!)
        }
        code5.becomeFirstResponder()
    }
    
    @IBAction func code5Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 1 {
            (sender as! UITextField).text = String(((sender as! UITextField).text?.last)!)
        }
        code6.becomeFirstResponder()
    }
    
    @IBAction func code6Edit(_ sender: Any) {
        if (sender as! UITextField).text?.count ?? 0 > 1 {
            (sender as! UITextField).text = String(((sender as! UITextField).text?.last)!)
        }
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
