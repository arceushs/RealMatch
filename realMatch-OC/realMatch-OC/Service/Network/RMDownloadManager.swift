//
//  RMDownloadManager.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/9/18.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
@objcMembers
@objc class RMDownloadManager: NSObject {
    
    static let shared = RMDownloadManager()
    
    private let manager = AFURLSessionManager(sessionConfiguration: .default)
    
    static let downloadedStr = "downloadedStr"
    
    var fileDirectory : String
    
    var downloadingArr : [String]?
    
    private var _downloadedArr:[String]?
    var downloadedArr : [String]?{
        get{
            return _downloadedArr
        }
        set{
            _downloadedArr = newValue
        }
    }
    
    override init() {
        self.fileDirectory = RMFileManager.pathForSavePreload()
        self.downloadingArr = []
        self._downloadedArr = []
        
        super.init()
        if let resultArr = UserDefaults.standard.value(forKey: RMDownloadManager.downloadedStr){
            self._downloadedArr = resultArr as? [String]
        }
    }
    
    func preloadUrl(_ urlStr:String?)->Void{
        if var urlStr = urlStr{
            self.downloadingArr!.append(urlStr)
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let thisURL = URL(string: urlStr)!
            let request = URLRequest(url: thisURL)
            let task = manager.downloadTask(with: request, progress: nil, destination: { (url, response) -> URL in
                let fileUrl = self.getFilePathFromUrl(urlStr)
                return URL(fileURLWithPath: fileUrl)
            }) { (response, url, error) in
                let lock = NSLock()
                lock.lock()
                if let index = self.downloadingArr!.index(of: urlStr){
                    self.downloadingArr!.remove(at: index)
                }
                if error == nil{
                    self.downloadedArr!.append(urlStr)
                    if self.downloadedArr?.count ?? 0 > 20{
                        let removeurl = self.downloadedArr?[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        self.downloadedArr?.remove(at: 0)
                        let removeURL = URL(string: removeurl ?? "")!
                        RMFileManager.removePreloadMp4(removeURL.lastPathComponent)
                    }
                    UserDefaults.standard.set(self.downloadedArr, forKey: RMDownloadManager.downloadedStr)
                    UserDefaults.standard.synchronize()
                }
                lock.unlock()
            }
            task.resume()
        }
    }
    
    func getFilePathFromUrl(_ urlStr:String) ->String{
        let thisURL = URL(string: urlStr)!
        let fileUrl = "\(self.fileDirectory)/\(thisURL.lastPathComponent)"
        return fileUrl
    }
}
