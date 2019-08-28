//
//  RMWebViewController.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/8/24.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
import WebKit

class RMWebViewController: UIViewController,RouterController,WKUIDelegate,WKNavigationDelegate {
    var url:String = ""
    required init!(routerParams params: [AnyHashable : Any]!) {
        super.init(nibName: nil, bundle: nil)
        self.url = params["url"] as? String ?? ""
    }
    
    func displayStyle() -> DisplayStyle {
        return .push
    }
    
    func animation() -> Bool {
        return true
    }
    
    required init!(command adopter: RouterAdopter!) {
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    var webview: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webview = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webview!)
        self.webview!.load(URLRequest(url:URL(string:url) ?? URL(string:"")!))
        
       
        self.webview!.navigationDelegate  = self
        self.webview!.uiDelegate = self
        // Do any additional setup after loading the view.
    }
    
    deinit {
        self.webview!.navigationDelegate = nil
        self.webview!.uiDelegate = nil
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
