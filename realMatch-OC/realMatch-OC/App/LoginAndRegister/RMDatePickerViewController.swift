//
//  RMDatePickerViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMDatePickerViewController: UIViewController,RouterController {
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init!(routerParams params: [AnyHashable : Any]!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBAction func datePicker(_ sender: Any) {
    }
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hintView: UILabel!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayStyle() -> DisplayStyle {
        return .push
    }
    
    func animation() -> Bool {
        return true
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hintView.isHidden = true
        self.birthdayTextField.isUserInteractionEnabled = false
        let currentTimeInterval = NSDate().timeIntervalSince1970
        let interval = TimeInterval(18 * 365 * 24 * 60 * 60 + 6 * 24 * 60 * 60)
        self.datePicker.maximumDate = Date(timeIntervalSince1970: currentTimeInterval - interval)
        // Do any additional setup after loading the view.
    }

    @IBAction func datePicked(_ sender: Any) {
        self.birthdayTextField.text = dateUtils.dateConvertString(self.datePicker.date, dateFormat: "yyyy-MM-dd")
    }
    
    @IBAction func continueClick(_ sender: Any) {
        let interval = NSDate().timeIntervalSince1970 - self.datePicker.date.timeIntervalSince1970
        if Double(interval) >= Double(18 * 365 * 24 * 60 * 60) && self.birthdayTextField.text?.count ?? 0 > 0 {
            Router.shared()?.router(to: "RMGenderViewController", parameter: nil)
            self.hintView.isHidden = true
            RMUserCenter.shared.registerBirth = self.birthdayTextField.text
            self.lineView.backgroundColor = UIColor(string: "323640")
        } else {
            self.hintView.isHidden = false
            self.lineView.backgroundColor = self.hintView.textColor
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
