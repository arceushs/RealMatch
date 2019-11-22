//
//  RMReportView.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/4.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMReportView: UIView,UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var cancelBlock : (()->Void)?
    var confirmBlock: ((String)->Void)?
    
    @IBOutlet weak var inAppropriateVideoView: UIView!
    
    @IBOutlet weak var SpamView: UIView!
    
    @IBOutlet weak var ReportTextField: UITextField!
    @IBOutlet weak var outterView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("RMReportView", owner: self, options: nil)?.first
        (view as! UIView).frame = frame
        self.addSubview(view as! UIView)
        
        let tapBlank = UITapGestureRecognizer(target: self, action: #selector(blankTapped))
        self.addGestureRecognizer(tapBlank)
        
        self.confirmButton.isUserInteractionEnabled = false;
        self.ReportTextField.delegate = self
        
        let tapVideoGest = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        self.inAppropriateVideoView.addGestureRecognizer(tapVideoGest)
        
        let tapSpamGest = UITapGestureRecognizer(target: self, action: #selector(spamTapped))
        self.SpamView.addGestureRecognizer(tapSpamGest)
    }
    
    @objc func videoTapped(){
        self.reset()
        self.inAppropriateVideoView.backgroundColor = UIColor(string:"F4F6FA")
        if let confirmBlock = self.confirmBlock{
            confirmBlock("Inappropriate Video")
        }
        
    }
    
    @objc func blankTapped(){
        self.ReportTextField.resignFirstResponder()
    }
    
    @objc func spamTapped(){
        self.reset()
        self.SpamView.backgroundColor = UIColor(string:"F4F6FA")
        if let confirmBlock = self.confirmBlock{
            confirmBlock("Feels like Spam")
        }
    }
    
    func reset(){
        self.SpamView.backgroundColor = UIColor.white
        self.inAppropriateVideoView.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func CancelButtonClicked(_ sender: Any) {
        if let cancelBlock = self.cancelBlock{
            cancelBlock()
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        if let confirmBlock = self.confirmBlock {
            confirmBlock(self.ReportTextField.text ?? "")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.reset()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0{
            self.confirmButton.isUserInteractionEnabled = true
            self.confirmButton.setTitleColor(UIColor(string: "FF008E")
                , for: .normal)
        }
    }
    
    
}
