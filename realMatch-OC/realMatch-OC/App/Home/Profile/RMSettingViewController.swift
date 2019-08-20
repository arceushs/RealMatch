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
        
        var emailBlock:((_ cell:RMSettingTableViewCell)->Void) = {
            cell in
            cell.nameLabel.text = "Email"
            cell.descLabel.text = RMUserCenter.shared.registerEmail
        }
        
        var passBlock:((_ cell:RMSettingTableViewCell)->Void) = {
            
        }
        
        self.settingTableView.delegate = self;
        self.settingTableView.dataSource = self;
        self.settingTableView.register(RMSettingTableViewCell.self, forCellReuseIdentifier: "RMSettingTableViewCell")
        self.settingTableView.tableHeaderView = RMSettingHeader(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*152.0/375.0))
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var settingTableView: UITableView!
    var settingArr:[String]?
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RMSettingTableViewCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
