//
//  RMRealVideoViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/3.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMRealVideoViewController: UIViewController,RouterController{
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
        
        
        let tapGest = UITapGestureRecognizer(target: self, action:#selector(shoot))
        self.shootView.addGestureRecognizer(tapGest)
        self.shootImageView.isHidden = true
        self.doneButton.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    @objc func shoot(){
        let adopter = RouterAdopter()
        adopter.params = ["filename":fileName]
        adopter.vcName = "RMCaptureViewController";
        adopter.routerAdopterCallback = {
            dict in
            let image = dict?["previewImage"]
            self.shootImageView.isHidden = false
            self.shootImageView.image = image ?? nil
        }
        Router.shared()?.router(to: adopter)
    }

    @IBOutlet weak var shootImageView: UIImageView!
    @IBOutlet weak var shootView: UIView!
    let fileName = "myfirstVideo"
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func continueClicked(_ sender: Any) {
//         let filePath = "\(RMFileManager.pathForSaveRecord())/\(fileName).mp4"
//         let postFileAPI = RMPostFileAPI(filePath: filePath, filename: fileName, userId: "dddd", mimeType: "video/mp4")
//        RMNetworkManager.share()?.request(postFileAPI, completion: { (response, error) in
//            let data = response?.responseObject;
//
//            if(data)
//        })
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
