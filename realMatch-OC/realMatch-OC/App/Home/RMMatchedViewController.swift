//
//  RMMatchedViewController.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/7/28.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit

@objc class RMMatchedViewController: UIViewController,RouterController {

    @IBOutlet weak var swipeButton: UIButton!
    @IBOutlet weak var EffectView: UIView!
    var visualEffectView:UIVisualEffectView?
    
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
        
        let blurEffect = UIBlurEffect(style: .light)
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView!.frame = self.EffectView.bounds
        self.EffectView.addSubview(self.visualEffectView!)
        
        self.swipeButton.layer.borderWidth = 3
        self.swipeButton.layer.borderColor = UIColor(string: "FA008E").cgColor
        self.swipeButton.layer.cornerRadius = 24
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        self.visualEffectView!.frame = self.EffectView.bounds
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
