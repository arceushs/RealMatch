//
//  RMNameViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objc class RMNameViewController: UIViewController,RouterController {
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init!(routerParams params: [AnyHashable : Any]!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hintView: UILabel!
    @IBOutlet weak var lineView: UIView!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayStyle() -> DisplayStyle {
        return .push
    }
    
    func animation() -> Bool {
        return true
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        if self.nameTextField.text?.count ?? 0 > 0 {
            self.hintView.isHidden = true
            self.lineView.backgroundColor = UIColor(string: "323640", alpha: 1)
            RMUserCenter.shared.registerName = self.nameTextField.text
            Router.shared()?.router(to: "RMDatePickerViewController", parameter: nil)
        }else{
            self.hintView.isHidden = false
            self.lineView.backgroundColor = self.hintView.textColor
        }
       
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hintView.isHidden = true
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(resign))
        self.view.addGestureRecognizer(tapGest)
        // Do any additional setup after loading the view.
    }
    
    @objc func resign(){
        self.nameTextField.resignFirstResponder()
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
