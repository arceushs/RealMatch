//
//  RMGenderViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMGenderViewController: UIViewController,RouterController {
    required init!(routerParams params: [AnyHashable : Any]!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayStyle() -> DisplayStyle {
        return .push
    }
    
    func animation() -> Bool {
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.womenButton.layer.cornerRadius = 24
        self.womenButton.layer.masksToBounds = true
        self.womenButton.layer.borderColor = UIColor(string: "C9CCD6").cgColor
        self.womenButton.layer.borderWidth = 2
        
        self.manButton.layer.cornerRadius = 24
        self.manButton.layer.masksToBounds = true
        self.manButton.layer.borderColor = UIColor(string: "FA008E").cgColor
        self.manButton.layer.borderWidth = 2;
        // Do any additional setup after loading the view.
    }
  
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womenButton: UIButton!
    
    
    
    @IBAction func continueClicke(_ sender: Any) {
        Router.shared()?.router(to: "RMRealVideoViewController", parameter: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func womenButtonClicked(_ sender: Any) {
        self.womenButton.layer.borderColor = UIColor(string: "FA008E").cgColor
        self.manButton.layer.borderColor = UIColor(string: "C9CCD6").cgColor
        self.womenButton.setTitleColor(UIColor(string: "FA008E"), for: .normal)
        self.manButton.setTitleColor(UIColor(string: "C9CCD6"), for: .normal)
    }
    
    @IBAction func manButtonClicked(_ sender: Any) {
        self.womenButton.layer.borderColor = UIColor(string: "C9CCD6").cgColor
        self.manButton.layer.borderColor = UIColor(string: "FA008E").cgColor
        self.manButton.setTitleColor(UIColor(string: "FA008E"), for: .normal)
        self.womenButton.setTitleColor(UIColor(string: "C9CCD6"), for: .normal)
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
