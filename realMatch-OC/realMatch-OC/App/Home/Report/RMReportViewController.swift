//
//  RMReportViewController.swift
//  realMatch-OC
//
//  Created by xulei on 2019/11/4.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMReportViewController: UIViewController,RouterController {
    var complainUser:String = ""
    var complaintedUser:String = ""
    required init!(routerParams params: [AnyHashable : Any]!) {
        self.complainUser = params["complainUser"] as! String
        self.complaintedUser = params["complainedUser"] as! String;
        super.init(nibName:nil, bundle:nil)
    }
    
    func displayStyle() -> DisplayStyle {
        .present
    }
    
    func animation() -> Bool {
        return true
    }
    
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    var reportView:RMReportView?
    private var _reportedView:UIView?
    var reportedView:UIView?{
        get{
            if(_reportedView == nil){
                _reportedView = Bundle.main.loadNibNamed("RMReportedView", owner: self, options: nil)?.last as! UIView
            }
            return _reportedView
        }
        set{
            _reportedView = newValue
        }
    }
    
    @objc func tapDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reportView = RMReportView(frame: UIScreen.main.bounds)
        self.view.addSubview(self.reportView!)
        self.view.backgroundColor = .black
        
        
        
        self.reportView?.cancelBlock = {
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        
        self.reportView?.confirmBlock = {
            text in
            
            let reportedContainerView = UIView(frame: self.view.bounds)
            self.view.addSubview(reportedContainerView)
            reportedContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDismiss)))
            
            reportedContainerView.addSubview(self.reportedView!)
            if self.complainUser.count > 0 && self.complaintedUser.count > 0 && self.reportView?.ReportTextField.text?.count ?? 0 > 0 {
                var complaintAPI = RMComplaintAPI(content: text ?? "", complaintUser: self.complainUser, complaintedUser: self.complaintedUser)
                RMNetworkManager.share()?.request(complaintAPI, completion: { (response) in
                    
                })
            }
            
            self.reportedView?.alpha = 0
            self.reportView!.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.reportedView?.alpha = 1
                self.reportView?.alpha = 0
            }
        }
        // Do any additional setup after loading the view.
    }


    override func viewWillLayoutSubviews() {
        self.reportedView?.frame = CGRect(x: (self.view.frame.size.width - (self.reportedView?.frame.width ?? 0))/2.0, y: (self.view.frame.size.height - (self.reportedView?.frame.height ?? 0))/2.0, width: self.reportedView?.frame.width ?? 0, height: self.reportedView?.frame.height ?? 0)
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
