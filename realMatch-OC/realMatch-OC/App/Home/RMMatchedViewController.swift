//
//  RMMatchedViewController.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/7/28.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
import SnapKit

@objc class RMMatchedViewController: UIViewController,RouterController {

    @IBOutlet weak var swipeButton: UIButton!
    @IBOutlet weak var EffectView: UIView!
    var visualEffectView:UIVisualEffectView?
    
    @IBOutlet weak var matchedAvatarImageView: UIImageView!
    @IBOutlet weak var myAvatarImageView: UIImageView!
    var matchedUserId:String = ""
    var matchedAvatar:String = ""
    var matchedUsername:String = ""
    
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init!(routerParams params: [AnyHashable : Any]!) {
        super.init(nibName: nil, bundle: nil)
        self.matchedUserId = "\(params["matchedUserId"] as? Int ?? 0)";
        self.matchedAvatar = params["matchedAvatar"] as? String ?? "";
        self.matchedUsername = params["matchedUsername"] as? String ?? "";
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
        
        let blurEffect = UIBlurEffect(style: .light)
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView!.frame = self.EffectView.bounds
        self.EffectView.addSubview(self.visualEffectView!)
        
        self.swipeButton.layer.borderWidth = 3
        self.swipeButton.layer.borderColor = UIColor(string: "FA008E").cgColor
        self.swipeButton.layer.cornerRadius = 24
        
        let testView = UIView()
        testView.backgroundColor = UIColor.clear
        self.swipeButton .addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.swipeButton)
        }
        
        self.matchedAvatarImageView.sd_setImage(with: URL(string: matchedAvatar), placeholderImage: UIImage(named: "default.jpeg"), options: .refreshCached, context: nil)
        
        let detailAPI = RMFetchDetailAPI(userId: RMUserCenter.shared.userId ?? "")
        RMNetworkManager.share()?.request(detailAPI, completion: { (response) in
            if let data = response?.responseObject as? RMFetchDetailAPIData {
                self.myAvatarImageView.sd_setImage(with: URL(string: data.avatar), placeholderImage: UIImage(named: "default.jpeg"), options: .refreshCached, context: nil)
            }
        })
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        self.visualEffectView!.frame = self.EffectView.bounds
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendMessageButtonClicked(_ sender: Any) {
        Router.shared()?.router(to: "RMMessageDetailViewController", parameter: ["fromUser":RMUserCenter.shared.userId,"toUser":self.matchedUserId,"fromUserName":self.matchedUsername,"avatar":self.matchedAvatar])
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
