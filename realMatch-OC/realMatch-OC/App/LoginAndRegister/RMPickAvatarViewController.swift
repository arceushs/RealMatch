//
//  RMPickAvatarViewController.swift
//  realMatch-OC
//
//  Created by xulei on 2020/4/15.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit
import Photos

class RMPickAvatarViewController: UIViewController, RouterController {
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
    
    @IBOutlet weak var shootView: UIView!
    
    let fileName = "MyAvatar"
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shootImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shootView.layer.cornerRadius = 4
        self.shootView.layer.shadowColor = UIColor(string: "000000", alpha: 0.1).cgColor
        self.shootView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.shootView.layer.shadowRadius = 4
        self.shootView.layer.shadowOpacity = 1
        self.shootImageView.contentMode = .scaleAspectFill
        self.shootImageView.layer.cornerRadius = 4
        self.shootImageView.layer.shadowColor = UIColor(string: "000000", alpha: 0.1).cgColor
        self.shootImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.shootImageView.layer.shadowRadius = 4
        self.shootImageView.layer.shadowOpacity = 1
        
        let tapGest = UITapGestureRecognizer(target: self, action:#selector(shoot))
        self.shootView.addGestureRecognizer(tapGest)
        self.shootImageView.isHidden = true
        
        self.doneButton.setTitle("Done", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @objc func shoot(){
        
        PHPhotoLibrary .requestAuthorization { (status) in
            DispatchQueue.main.async{
                if status == PHAuthorizationStatus.authorized {
                    let adopter = RouterAdopter()
                    adopter.vcName = "RMPhotoViewController"
                    adopter.routerAdopterCallback = { dict in
                        let image = dict?["previewImage"]
                        self.shootImageView.isHidden = false
                        self.shootImageView.image = image as? UIImage
                    }
                    
                    Router.shared()?.router(to: adopter)
                } else {
                    SVProgressHUD.show(withStatus: "Authorize access to get the avatar");
                }
            }
        }
    }

    @IBOutlet weak var hintLabel: UILabel!
    @IBAction func upload(_ sender: Any) {
        guard let image = self.shootImageView.image else {
            self.hintLabel.text = "please choose a avatar"
            return
        }
        SVProgressHUD.show()
        let registerAPI = RMRegisterAPI(name: RMUserCenter.shared.registerName ?? "", birth: RMUserCenter.shared.registerBirth ?? "", sex: RMUserCenter.shared.registerSex ?? 1,userId: RMUserCenter.shared.userId ?? "", avatar: image)
        RMNetworkManager.share()?.request(registerAPI, completion: { (response) in
           SVProgressHUD.dismiss()
           let data:RMRegisterAPIData? = response?.responseObject as? RMRegisterAPIData
           if data?.result ?? false{
                if data?.appToken.length ?? 0 > 0 {
                    UserDefaults.standard.set(data?.appToken, forKey: "global-token")
                    Router.shared()?.router(to: "RMHomePageViewController", parameter: nil)
                } else {
                    SVProgressHUD.showInfo(withStatus: "Authentication Failure")
                }
           }
        })
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
