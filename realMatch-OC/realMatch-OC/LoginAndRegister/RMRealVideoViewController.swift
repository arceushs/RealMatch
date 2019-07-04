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
        self.shootImageView.layer.cornerRadius = 4
        self.shootImageView.layer.shadowColor = UIColor.red.cgColor
        self.shootImageView.layer.shadowOffset = CGSize(width: 10, height: 12)
        self.shootImageView.layer.shadowRadius = 4
        self.shootImageView.layer.opacity = 1
        
        
        let tapGest = UITapGestureRecognizer(target: self, action:#selector(shoot))
        self.shootImageView.addGestureRecognizer(tapGest)
        // Do any additional setup after loading the view.
    }
    
    @objc func shoot(){
        Router.shared()?.router(to: "RMCaptureViewController", parameter: ["filename":"myfirstVideo"])
    }

    @IBOutlet weak var shootImageView: UIView!
    
    @IBAction func continueClicked(_ sender: Any) {
         let filePath = "\(RMFileManager.pathForSaveRecord())/myfirstVideo.mp4"
         let postFileAPI = RMPostFileAPI(filename: filePath, userId: "")
        RMNetworkManager.share()?.request(postFileAPI, completion: { (response, error) in
            
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

}
