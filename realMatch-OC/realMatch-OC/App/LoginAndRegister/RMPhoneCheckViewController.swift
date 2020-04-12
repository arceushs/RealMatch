//
//  RMPhoneCheckViewController.swift
//  realMatch-OC
//
//  Created by xulei on 2020/4/9.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit

class RMPhoneCheckViewController: UIViewController, RouterController {
    required init!(routerParams params: [AnyHashable : Any]!) {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(resign))
        self.view.addGestureRecognizer(tapGest)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func resign(){
        self.phoneTextField.resignFirstResponder()
    }
    
    @IBOutlet weak var phoneEmptyHintLabel: UILabel!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBAction func countrySelectedButton(_ sender: Any) {
        let countryCodeVC = XWCountryCodeController()
        countryCodeVC.returnCountryCodeBlock = {
            (contryName,code) in
            self.countryCodeLabel.text = "+\(code ?? "")"
        }
        self.navigationController?.pushViewController(countryCodeVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.phoneEmptyHintLabel.isHidden = true
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        if self.countryCodeLabel.text?.count ?? 0 <= 0 || self.phoneTextField.text?.count ?? 0 <= 0 {
            self.phoneEmptyHintLabel.isHidden = false
        } else {
            Router.shared()?.router(to: "RMPhoneCheckCodeViewController", parameter: ["phoneNum":self.phoneTextField.text,"phoneCountryCode": self.countryCodeLabel.text])
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
