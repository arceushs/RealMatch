//
//  RMPlayer.swift
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/20.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
import AVFoundation

class RMPlayer: NSObject {
    var internalPlayer:AVPlayer!
    
    static let instance:RMPlayer = RMPlayer()
    class func shared() -> RMPlayer{
        return instance
    }
    
    override init() {
        super.init()
        let playerItem = AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: "")))
        self.internalPlayer = AVPlayer(playerItem: playerItem)
    }
    
    @objc func play() -> Void{
        internalPlayer.play()
    }
    
    @objc func pause(){
        internalPlayer.pause()
    }
    
    func replaceItemWithURL(_ url:URL){
        let playerItem = AVPlayerItem(url: url)
        self.internalPlayer.replaceCurrentItem(with: playerItem)
    }
}

extension RMPlayer{
    
}
