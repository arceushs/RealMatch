//
//  RMMessageHeader.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/7/6.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit


@objc class RMMessageHeader: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    var likesMeCollectionView:UICollectionView!
    var labelTitle:UILabel!
    var labelCount:UILabel!
    var visualEffectView:UIVisualEffectView!
    var likesMeArr:[RMFetchLikesMeModel]?
    
    @objc init(frame: CGRect,likesMeArr :[RMFetchLikesMeModel]?) {
        super.init(frame: frame)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 64, height: 64)
        flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16)
        self.likesMeCollectionView = UICollectionView(frame: CGRect(x: 0, y: 60, width: self.bounds.width, height: 100), collectionViewLayout: flowLayout)
        self.likesMeCollectionView.backgroundColor = .white
        self.likesMeCollectionView.delegate = self;
        self.likesMeCollectionView.dataSource = self;
        self.likesMeCollectionView.register(UINib(nibName: "RMMessageHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RMMessageHeaderCollectionViewCell")
        self.addSubview(self.likesMeCollectionView)
        self.labelTitle = UILabel(frame: CGRect(x: 16, y: 40, width: 300, height: 16))
        self.labelTitle.text = "Likes me"
        self.addSubview(self.labelTitle)
        
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        visualEffectView.frame = self.likesMeCollectionView.frame
        self.addSubview(visualEffectView)
        visualEffectView.alpha = 0.9
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(routeToPurchase))
        visualEffectView.addGestureRecognizer(gest)
        
    }
    
    @objc func routeToPurchase(){
        Router.shared()?.router(to: "RMPurchaseViewController", parameter: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMMessageHeaderCollectionViewCell", for: indexPath) as? RMMessageHeaderCollectionViewCell ?? UICollectionViewCell()
        return cell
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
