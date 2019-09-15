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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
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
    
    var gradientlayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientlayer.startPoint = CGPoint(x: 0, y: 0)
        gradientlayer.endPoint = CGPoint(x: 0, y: 1)
        gradientlayer.frame = self.premiumView.bounds
        gradientlayer.locations = [NSNumber(value: 0),NSNumber(value: 1)];
        gradientlayer.colors = [UIColor(string: "ff0052").cgColor,UIColor(string: "ffbb00").cgColor]
        self.premiumView.layer .insertSublayer(gradientlayer, at: 0)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(premiumViewClicked))
        self.premiumView.addGestureRecognizer(tapGest)
        
        if UIScreen.main.bounds.width <= 325.0{
            self.containerViewHeightConstraint.constant = 50
        }

        if let userId = RMUserCenter.shared.userId{
            let detailAPI = RMFetchDetailAPI(userId: userId)
            RMNetworkManager.share()?.request(detailAPI, completion: { (response) in
                if response?.error != nil{
                    return
                }
                let data = response?.responseObject as? RMFetchDetailAPIData
                RMUserCenter.shared.registerSex = data?.sex
                RMUserCenter.shared.registerName = data?.name
                RMUserCenter.shared.registerEmail = data?.email
                RMUserCenter.shared.avatar = data?.avatar
                
                if let avatar = data?.avatar{
                    self.avatarImageView?.sd_setImage(with: URL(string: avatar), placeholderImage: UIImage(named: "default.jpeg"), options: .refreshCached, context: nil)
                    self.nameLabel.text = RMUserCenter.shared.registerName
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func premiumViewClicked(){
        Router.shared()?.router(to: "RMPurchaseViewController", parameter: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientlayer.frame = self.premiumView.bounds
        
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
