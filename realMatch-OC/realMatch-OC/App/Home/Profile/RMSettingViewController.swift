//
//  RMSettingViewController.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/8/19.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

class RMSettingViewController: UIViewController,RouterController,UITableViewDelegate,UITableViewDataSource {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let privacy:((_ cell:RMSettingTableViewCell)->Void) = {
            cell in
            cell.nameLabel.text = "Privacy policy"
        }
        
        let terms:(_ cell:RMSettingTableViewCell)->Void = {
            cell in
            cell.nameLabel.text = "Terms of use"
        }
                
        self.settingArr = [privacy,terms]
        self.settingTableView.separatorStyle = .none
        self.settingTableView.delegate = self;
        self.settingTableView.dataSource = self;
        self.settingTableView.register(UINib(nibName: "RMSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "RMSettingTableViewCell")
        self.settingTableView.tableHeaderView = RMSettingHeader(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*152.0/375.0))
        
        var footerView = RMSettingFooter(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 130))
        footerView.buttonBlock = {
            UserDefaults.standard.set(nil, forKey: "global-userId")
            UserDefaults.standard.set(nil, forKey: "global-token")
            UserDefaults.standard.set(false, forKey: "global-vip")
            UserDefaults.standard.synchronize()
            Router.shared()?.router(to: "LoginAndRegisterViewController", parameter: nil)
        }
        self.settingTableView.tableFooterView = footerView
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var settingTableView: UITableView!
    var settingArr:[(_ cell:RMSettingTableViewCell)->Void]?
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMSettingTableViewCell", for: indexPath) as! RMSettingTableViewCell
        guard let block = self.settingArr?[indexPath.row] else { return cell }
        block(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,animated:false)
        if(indexPath.row == 0){
            Router.shared()?.router(to: "RMWebViewController", parameter:["url":"https://www.4match.top/policy.html"] )
        }else{
            Router.shared()?.router(to: "RMWebViewController", parameter:["url":"https://www.4match.top/terms.html"] )
        }
        
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
