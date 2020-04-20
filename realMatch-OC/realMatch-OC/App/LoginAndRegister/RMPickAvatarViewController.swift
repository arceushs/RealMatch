//
//  RMPickAvatarViewController.swift
//  realMatch-OC
//
//  Created by xulei on 2020/4/15.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit

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
        self.doneButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @objc func shoot(){
        let adopter = RouterAdopter()
        adopter.vcName = "RMPhotoViewController"
        adopter.routerAdopterCallback = { dict in
            let image = dict?["previewImage"]
            self.shootImageView.isHidden = false
            self.shootImageView.image = image as? UIImage
            self.doneButton.isEnabled = true
        }
        
        Router.shared()?.router(to: adopter)
    }

    @IBOutlet weak var hintLabel: UILabel!
    @IBAction func upload(_ sender: Any) {
        if self.doneButton.currentTitle == "Done"{
           
           let registerAPI = RMRegisterAPI(name: RMUserCenter.shared.registerName ?? "", birth: RMUserCenter.shared.registerBirth ?? "", sex: RMUserCenter.shared.registerSex ?? 1,userId: RMUserCenter.shared.userId ?? "")
           RMNetworkManager.share()?.request(registerAPI, completion: { (response) in
               let data:RMRegisterAPIData? = response?.responseObject as? RMRegisterAPIData
               if data?.result ?? false{
                   Router.shared()?.router(to: "RMHomePageViewController", parameter: nil)
               }
           })
           return
        }

        self.doneButton.isEnabled = false

        let filePath = "\(RMFileManager.pathForSaveRecord())/\(fileName).png"
        if let image = self.shootImageView.image{
            let data:Data? = UIImagePNGRepresentation(image) ?? nil
            do {
                try data?.write(to: URL(fileURLWithPath: filePath))
            } catch {
                return 
            }
            
            let postFileAPI = RMPostFileAPI(filePath: filePath, filename: fileName, userId: RMUserCenter.shared.userId ?? "", mimeType: "image/png",fileType: 0)
            SVProgressHUD.show()
            RMNetworkManager.share()?.request(postFileAPI, completion: { (response) in
               SVProgressHUD.dismiss()
               self.doneButton.isEnabled = true
               let data = response?.responseObject as? RMPostFileAPIData
               if(data?.result ?? false){
                   self.hintLabel.text = "Upload Success"
                   self.doneButton.setTitle("Done", for: .normal)
               }else{
                   self.hintLabel.text = "Upload failure,try again!"
               }

            })
        }
        
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
