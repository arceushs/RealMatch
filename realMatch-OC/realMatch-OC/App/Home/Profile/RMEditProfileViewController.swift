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
    var videoArr:[RMFetchVideoDetailModel]?
    var count = 0;

    @IBOutlet weak var testEnviromentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(testSwitchButtonClicked))
        self.testEnviromentLabel.isUserInteractionEnabled = true
        self.testEnviromentLabel.addGestureRecognizer(tapGest)
        
        self.editProfileDetailTableView.delegate = self
        self.editProfileDetailTableView.dataSource = self
        self.editProfileDetailTableView.register(UINib(nibName: "RMEditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "editprofileCell")
        self.editProfileDetailTableView.separatorStyle = .none;
        let headerView = RMEditProfileHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 189))
        self.editProfileDetailTableView.tableHeaderView = headerView
        if let userId = RMUserCenter.shared.userId{
            let fetchDetailAPI:RMFetchDetailAPI = RMFetchDetailAPI(userId: userId)
            RMNetworkManager.share()?.request(fetchDetailAPI, completion: { (response) in
                if response?.error == nil{
                    let result =  response?.responseObject as! RMFetchDetailAPIData
                    self.videoArr = result.videoArr
                    let startIndex = (self.videoArr?.count ?? 0)
                    if startIndex <= 2{
                        for _ in startIndex...2{
                            let model = RMFetchVideoDetailModel()
                            self.videoArr?.append(model)
                        }

                    }
                                        
                    if let videoArr = self.videoArr{
                        for (i,model) in videoArr.enumerated(){
//                            if i == 0{
//                                model.title = "About me";
//                                model.subtitle = "who are you, where are you from, your school, your job.";
//                            }else if i == 1{
//                                model.title = "Interests";
//                                model.subtitle = "what make you differ";
//                            }else if i == 2{
//                                model.title = "My friends";
//                                model.subtitle = "Who do you like to be with";
//                            }
                        }

                    }
                    

                    headerView.avatarView!.sd_setImage(with: URL(string:result.avatar), placeholderImage: UIImage(named: "default.jpeg"), options: SDWebImageOptions.queryMemoryData, completed: nil)
                    headerView.nameLabel.text = "\(result.name) \(result.age)"
                    headerView.isVip.isHidden = !result.recharged
//                    headerView.descriptionLabel =
                    
                    self.editProfileDetailTableView.reloadData()
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RMEditProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "editprofileCell") as! RMEditProfileTableViewCell
        cell.selectionStyle = .none
        if let videoArr = self.videoArr{
            if videoArr.count > 0{
                let model = videoArr[indexPath.row]
                cell.subTitleLabel.text = model.subtitle;
                if model.videoImg.ossLocation.count > 0 || model.previewVideoImage.size.height>0.0{
                    cell.addVideoView.isHidden = true
                    if model.previewVideoImage.size.height>0.0{
                        cell.detailImageView.image = model.previewVideoImage
                    }else{
                        cell.detailImageView.sd_setImage(with: URL(string: model.videoImg.ossLocation), completed: nil)
                    }
                }else{
                    cell.addVideoView.isHidden = false
                }
                
                if indexPath.row == 0{
                    cell.cellType = .typeEdit
                }else{
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
                            let fileName = model.title
                            let filePath = "\(RMFileManager.pathForSaveRecord())/\(fileName).mp4"
                            let postFileAPI = RMPostFileAPI(filePath: filePath, filename: fileName, userId: RMUserCenter.shared.userId ?? "", mimeType:"video/mp4", fileType: Int32(indexPath.row)+1)
                            SVProgressHUD.show(withStatus: "uploading...")
                            RMNetworkManager.share()?.request(postFileAPI, completion: { (response) in
                                if response?.error != nil{
                                    SVProgressHUD.showError(withStatus: "upload error,please try again")
                                }else{
                                    SVProgressHUD.showSuccess(withStatus: "upload success")
                                    let image = dict?["previewImage"] as? UIImage
                                    if let image = image{
                                        model.previewVideoImage = image
                                    }
                                    self.editProfileDetailTableView.reloadData()
                                }
                            })

                        }
                        Router.shared()?.router(to: adopter)
                    case .typeDelete:
                        let deleteAPI = RMDeleteFileAPI(uploadId: "\(uploadId: model.videoImg.uploadId)")
                        RMNetworkManager.share()?.request(deleteAPI, completion: { (response) in
                            
                        })
                    default:
                        let model = RMFetchVideoDetailModel()
                        self.videoArr?[indexPath.row] = model;
                        if indexPath.row == 0{
                            model.title = "About me";
                            model.subtitle = "who are you, where are you from, yuor school, your job.";
                        }else if indexPath.row == 1{
                            model.title = "Interests";
                            model.subtitle = "what make you differ";
                        }else if indexPath.row == 2{
                            model.title = "My friends";
                            model.subtitle = "Who do you like to be with";
                        }

                        
                    }
                    self.editProfileDetailTableView.reloadData()
                }
            }
        }
        return cell
    }
    
    @IBAction func changeUserOtherInfoClicked(_ sender: Any) {
        Router.shared()?.router(to: "RMChnageEditProfileViewController", parameter: nil)
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
        if let videoArr = self.videoArr{
            let cell = tableView.cellForRow(at: indexPath) as! RMEditProfileTableViewCell
            let model = videoArr[indexPath.row]
            if model.videoImg.ossLocation.count > 0{
                return
//                cell.addVideoView.isHidden = true
//                cell.cellType = .typeEdit
//                cell.detailImageView.sd_setImage(with: URL(string: model.videoImg.ossLocation), completed: nil)
            }else{
                cell.addVideoView.isHidden = false
                cell.cellType = .typeDelete
            }
            
            let adopter = RouterAdopter()
            adopter.params = ["filename":model.title]
            adopter.vcName = "RMCaptureViewController";
            adopter.routerAdopterCallback = {
                dict in
                let fileName = model.title
                let filePath = "\(RMFileManager.pathForSaveRecord())/\(fileName).mp4"
                let postFileAPI = RMPostFileAPI(filePath: filePath, filename: fileName, userId: RMUserCenter.shared.userId ?? "", mimeType:"video/mp4", fileType: Int32(indexPath.row)+1)
                SVProgressHUD.show(withStatus: "uploading...")
                RMNetworkManager.share()?.request(postFileAPI, completion: { (response) in
                    if response?.error != nil{
                        SVProgressHUD.showError(withStatus: "upload error,please try again")
                    }else{
                        SVProgressHUD.showSuccess(withStatus: "upload success")
                        let image = dict?["previewImage"] as? UIImage
                        if let image = image{
                            model.previewVideoImage = image
                        }
                        self.editProfileDetailTableView.reloadData()
                    }
                })
            }
            Router.shared()?.router(to: adopter)

        }
        
    }
    
    @objc func testSwitchButtonClicked(_ sender: Any) {
        count = count + 1
        if count == 3 {
            count = 0;
            let currentEnviroment = UserDefaults.standard.bool(forKey: "testEnviroment")
            UserDefaults.standard.set(!currentEnviroment, forKey: "testEnviroment")
            SVProgressHUD.showSuccess(withStatus: "change success");
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
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
