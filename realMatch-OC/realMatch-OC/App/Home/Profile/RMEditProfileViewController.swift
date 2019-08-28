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
        self.editProfileDetailTableView.register(UINib(nibName: "RMEditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "editprofileCell")
        self.editProfileDetailTableView.separatorStyle = .none;
        if let userId = RMUserCenter.shared.userId{
            let fetchDetailAPI:RMFetchDetailAPI = RMFetchDetailAPI(userId: userId)
            RMNetworkManager.share()?.request(fetchDetailAPI, completion: { (response) in
                if response?.error == nil{
                    let result =  response?.responseObject as! RMFetchDetailAPIData
                    self.videoArr = result.videoArr
                    self.editProfileDetailTableView.reloadData()
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RMEditProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "editprofileCell") as! RMEditProfileTableViewCell
        if let videoArr = self.videoArr{
            if videoArr.count > 0{
                let model = videoArr[indexPath.row]
                cell.titleLabel.text = model.title
                cell.subTitleLabel.text = model.subtitle;
                if model.videoImg.count > 0{
                    cell.addVideoView.isHidden = true
                    cell.cellType = .typeEdit
                }else{
                    cell.addVideoView.isHidden = false
                    cell.cellType = .typeDelete
                }
                cell.editButtonBlock = {
                    type in
                    switch type{
                    case .typeEdit:
                        let adopter = RouterAdopter()
                        adopter.params = ["filename":model.title]
                        adopter.vcName = "RMCaptureViewController";
                        adopter.routerAdopterCallback = {
                            dict in
                            let image = dict?["previewImage"]
                            cell.detailImageView.image = image as? UIImage
                            cell.detailImageView.isHidden = false
                            cell.addVideoView.isHidden = true
                        }
                        Router.shared()?.router(to: adopter)
                    default:
                        self.videoArr?.remove(at: indexPath.row)
                        self.editProfileDetailTableView.deleteRows(at: [indexPath], with: .left)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let videoArr = self.videoArr{
            if videoArr.count>indexPath.row{
                let model = videoArr[indexPath.row]
                return model.rowHeight;
            }
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
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
