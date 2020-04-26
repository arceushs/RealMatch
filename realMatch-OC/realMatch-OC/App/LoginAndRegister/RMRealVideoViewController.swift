//
//  RMRealVideoViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMRealVideoViewController: UIViewController,RouterController{
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName: nil, bundle: nil)
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    @objc func shoot(){
        let adopter = RouterAdopter()
        adopter.params = ["filename":fileName]
        adopter.vcName = "RMCaptureViewController";
        adopter.routerAdopterCallback = {
            dict in
            let image = dict?["previewImage"]
            self.shootImageView.isHidden = false
            self.shootImageView.image = image as? UIImage
            self.doneButton.isEnabled = true

        }
        Router.shared()?.router(to: adopter)
    }

    @IBOutlet weak var shootImageView: UIImageView!
    @IBOutlet weak var shootView: UIView!
    let fileName = "About me"
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    
    var agreeTextView: RMAgreeTextView?
    var flag = false
    
    @IBAction func continueClicked(_ sender: Any) {
        if self.doneButton.currentTitle == "Done"{
            if flag == false {
                agreeTextView = RMAgreeTextView(frame: self.view.bounds)
                agreeTextView?.agreeButton.addTarget(self, action: #selector(gotIt), for: .touchDown)
                agreeTextView?.agreeLabel.text = "Congratulations! You have completed the registration! We will review your video to ensure it meets our terms. Your video will not be seen by others before passing the review, but you can still use all th features of our app normally"
                self.view.addSubview(agreeTextView!)
                flag = true
            }
            
            if let vcs = self.navigationController?.viewControllers{
                var finalVC:UIViewController? = nil
                for vc in vcs{
                    if vc is RMHomePageDetailViewController || vc is RMHomePageViewController{
                        finalVC = vc
                    }
                }
                if finalVC != nil {
                    self.navigationController?.popToViewController(finalVC!, animated: true)
                }
                
            }
            

            return
        }
        
        self.doneButton.isEnabled = false
 
        let filePath = "\(RMFileManager.pathForSaveRecord())/\(fileName).mp4"
        let postFileAPI = RMPostFileAPI(filePath: filePath, filename: fileName, userId: RMUserCenter.shared.userId ?? "", mimeType: "video/mp4",fileType: 1)
        SVProgressHUD.show()
        RMNetworkManager.share()?.request(postFileAPI, completion: { (response) in
            SVProgressHUD.dismiss()
            self.doneButton.isEnabled = true
            let data = response?.responseObject as? RMPostFileAPIData
            if(data?.result ?? false){
                self.hintLabel.text = "Upload Success"
                self.doneButton.setTitle("Done", for: .normal)
                RMUserCenter.shared.isUploadedVideo = true
            }else{
                self.hintLabel.text = "Upload failure,try again!"
            }

        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gotIt() {
        agreeTextView?.removeFromSuperview()
    }
    
}
