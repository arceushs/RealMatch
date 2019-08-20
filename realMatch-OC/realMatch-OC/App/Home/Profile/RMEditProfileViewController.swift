//
//  QTEditingProfileViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/19.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMEditProfileViewController: UIViewController,RouterController,UITableViewDelegate,UITableViewDataSource {
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
    
    
    @IBOutlet weak var editProfileDetailTableView: UITableView!
    var videoArr:[RMFetchDetailModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editProfileDetailTableView.delegate = self
        self.editProfileDetailTableView.dataSource = self
        
        if let userId = RMUserCenter.shared.userId{
            let fetchDetailAPI:RMFetchDetailAPI = RMFetchDetailAPI(userId: userId)
            RMNetworkManager.share()?.request(fetchDetailAPI, completion: { (response) in
                if response?.error == nil{
                    let result =  response?.responseObject as! RMFetchDetailAPIData
                    self.videoArr = result.videoArr
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RMEditProfileTableViewCell = RMEditProfileTableViewCell(style: .default, reuseIdentifier: "editprofileCell")
        if let videoArr = self.videoArr{
            let model = videoArr[indexPath.row]
            cell.titleLabel.text = model.name
            if model.videoImg.count > 0{
                cell.addVideoView.isHidden = true
                cell.detailImageView.sd_setImage(with: URL(string: model.videoImg), completed: nil)
            }else{
                cell.addVideoView.isHidden = false
            }
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoArr?.count ?? 0
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
