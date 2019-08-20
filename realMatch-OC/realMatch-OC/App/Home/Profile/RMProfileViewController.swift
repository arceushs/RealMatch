//
//  RMProfileViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/16.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMProfileViewController: UIViewController,RouterController{
    
    @IBOutlet weak var premiumView: UIView!
    
    required init!(routerParams params: [AnyHashable : Any]!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    func displayStyle() -> DisplayStyle {
        return DisplayStyle.push
    }
    
    func animation() -> Bool {
        return true
    }
    
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.startPoint = CGPoint(x: 0, y: 0)
        gradientlayer.endPoint = CGPoint(x: 0, y: 1)
        gradientlayer.frame = self.premiumView.bounds
        gradientlayer.locations = [NSNumber(value: 0),NSNumber(value: 1)];
        gradientlayer.colors = [UIColor(string: "ff0052").cgColor,UIColor(string: "ffbb00").cgColor]
        self.premiumView.layer .insertSublayer(gradientlayer, at: 0)

        // Do any additional setup after loading the view.
    }


    @IBAction func routerToSetting(_ sender: Any) {
        Router.shared()?.router(to: "RMSettingViewController", parameter: nil)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func routerToEditing(_ sender: Any) {
        Router.shared()?.router(to: "RMEditProfileViewController", parameter: nil)
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
