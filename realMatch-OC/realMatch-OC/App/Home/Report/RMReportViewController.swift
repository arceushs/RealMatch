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
        self.complainUser = params["complainUser"]
        self.complaintedUser = params["complainedUser"];
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
            _reportedView = Bundle.main.loadNibNamed("RMReportedView", owner: self, options: nil)?.last as! UIView
            return _reportedView
        }
        set{
            _reportedView = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reportView = RMReportView()
        self.view.addSubview(self.reportView!)
        self.view.backgroundColor = .black
        
        
        
        self.reportView?.cancelBlock = {
            self.dismiss(animated: true, completion: nil)
            
        }
        
        self.reportView?.confirmBlock = {
            self.reportedView?.center = CGPoint(x: self.view.frame.size.width/2.0, y: self.view.frame.size.height/2.0)
            self.view.addSubview(self.reportedView!)
            self.dismiss(animated: true, completion: nil)
            if self.complainUser.count > 0 && self.complaintedUser.count > 0 && self.reportView?.ReportTextField.text.count ?? 0 > 0 {
                var complaintAPI = RMComplaintAPI(content: self.reportView?.ReportTextField.text ?? "", complaintUser: self.complainUser, complaintedUser: self.complaintedUser)
                RMNetworkManager.share()?.request(complaintAPI, completion: { (response) in
                    var data:RMComplaintAPIData = response?.responseObject ?? RMComplaintAPIData();
                    if data.code == 200 {
                        
                    }
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
