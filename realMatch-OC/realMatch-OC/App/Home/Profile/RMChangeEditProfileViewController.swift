//
//  RMChangeEditProfileViewController.swift
//  realMatch-OC
//
//  Created by xulei on 2020/5/25.
//  Copyright © 2020 qingting. All rights reserved.
//

import Photos
import UIKit

class RMChangeEditProfileViewController: UIViewController,RouterController,UITextViewDelegate {
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
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myJobLabel.layer.cornerRadius = 8
        self.myJobLabel.layer.borderColor = UIColor(string: "C9CCD6").cgColor
        self.myJobLabel.layer.borderWidth = 1
        
        self.mySchoolLabel.layer.cornerRadius = 8
        self.mySchoolLabel.layer.borderColor = UIColor(string: "C9CCD6").cgColor
        self.mySchoolLabel.layer.borderWidth = 1
        
        self.aboutmeLabel.layer.cornerRadius = 8
        self.aboutmeLabel.layer.borderColor = UIColor(string: "C9CCD6").cgColor
        self.aboutmeLabel.layer.borderWidth = 1
        self.aboutmeLabel.delegate = self
        
        let tapGest = UIGestureRecognizer(target: self, action: #selector(tapGest(_ :)))
        self.view.addGestureRecognizer(tapGest)
        
        self.scrollView.delegate = self
        
        if RMUserCenter.shared.avatar?.count ?? 0 > 0 {
            self.avatarImageView.sd_setImage(with: URL(string: RMUserCenter.shared.avatar ?? ""), placeholderImage: UIImage(named: "default.jpeg"), options: .refreshCached, context: nil)
        } else {
            let detailAPI = RMFetchDetailAPI(userId: RMUserCenter.shared.userId ?? "")
            RMNetworkManager.share()?.request(detailAPI, completion: { (response) in
                if let data = response?.responseObject as? RMFetchDetailAPIData {
                    self.avatarImageView.sd_setImage(with: URL(string: data.avatar), placeholderImage: UIImage(named: "default.jpeg"), options: .refreshCached, context: nil)
                }
            })
        }
        
        self.avatarImageView.isUserInteractionEnabled = true
        let tapGestAvatar = UITapGestureRecognizer(target: self, action: #selector(chooseImageView))
        self.avatarImageView.addGestureRecognizer(tapGestAvatar)
    }
    
    @objc func chooseImageView() {
        PHPhotoLibrary .requestAuthorization { (status) in
            DispatchQueue.main.async{
                if status == PHAuthorizationStatus.authorized {
                    let adopter = RouterAdopter()
                    adopter.vcName = "RMPhotoViewController"
                    adopter.routerAdopterCallback = { dict in
                        let image = dict?["previewImage"]
                        self.avatarImageView.isHidden = false
                        self.avatarImageView.image = image as? UIImage
                    }
                    self.flag = true
                    Router.shared()?.router(to: adopter)
                } else {
                    SVProgressHUD.show(withStatus: "Authorize access to get the avatar");
                }
            }
        }
    }
    
    @objc func tapGest(_ : UIGestureRecognizer?){
        self.myJobLabel.resignFirstResponder()
        self.mySchoolLabel.resignFirstResponder()
        self.aboutmeLabel.resignFirstResponder()
    }

    @IBOutlet weak var aboutmeLabel: UITextView!
    @IBOutlet weak var myJobLabel: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var mySchoolLabel: UITextField!
    
    var flag :Bool = false
    // MARK:
    
    func textViewDidChange(_ textView: UITextView) {
        self.countLabel.text = "\(textView.text.count)/300"
        if textView.text.count >= 299 {
            let index = textView.text.startIndex
            let endIndex = textView.text.index(index, offsetBy: 300)
            textView.text = String(textView.text[index..<endIndex])
            return
        }
    }
    
    // MARK:
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tapGest(nil)
    }

    @IBAction func doneButtonClicked(_ sender: Any) {
        var str:String?
        if self.flag {
            str = UIImagePNGRepresentation(self.avatarImageView.image!)?.base64EncodedString(options: .lineLength64Characters)
        } else {
            str = nil
        }
        
        RMNetworkManager.share()?.request(RMChangeUserOtherInfoAPI(school: self.mySchoolLabel.text, job: self.myJobLabel.text, aboutMe: self.aboutmeLabel.text, avatar: str), completion: { (response) in
            if response?.error != nil {
                SVProgressHUD.showInfo(withStatus: "encounter error try it again")
                return
            }
            let data :RMChangeUserOtherInfoAPIData = response?.responseObject as! RMChangeUserOtherInfoAPIData
            SVProgressHUD.showInfo(withStatus: data.message)
            self.navigationController?.popViewController(animated: true)
        })
    }
}
