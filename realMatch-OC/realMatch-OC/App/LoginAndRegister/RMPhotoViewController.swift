//
//  RMPhotoViewController.swift
//  realMatch-OC
//
//  Created by xulei on 2020/4/15.
//  Copyright © 2020 qingting. All rights reserved.
//

import UIKit
import Photos

class RMPhotoViewController: UIViewController, RouterController, UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMPhotoCollectionViewCell", for: indexPath) as! RMPhotoCollectionViewCell
        guard let image = self.dataSource[indexPath.row].image else {
            self.getImageFromPHAsset(assetModel: self.dataSource[indexPath.row], size: CGSize(width: 1000, height: 1000), cell: cell)
            return cell
        }
        cell.photoImageView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let assetModel:RMAssetModel = self.dataSource[indexPath.row]
        if let image = assetModel.image {
            if self.adopter?.routerAdopterCallback != nil {
                self.adopter?.routerAdopterCallback(["previewImage":image])
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
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
        self.adopter = adopter
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("cannot init with coder")
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAllPHAssetFromSystem()
        self.collectionView.register(UINib(nibName: "RMPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RMPhotoCollectionViewCell")
        let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let itemW = (UIScreen.main.bounds.width - 36)/3.0
        let itemH = itemW
        flowLayout?.itemSize = CGSize(width: itemW,height: itemH)
        flowLayout?.minimumInteritemSpacing = 6
        flowLayout?.minimumLineSpacing = 6
        self.collectionView.contentInset = UIEdgeInsetsMake(12, 12, 12, 12)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    var dataSource:[RMAssetModel] = []
    var adopter:RouterAdopter?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    func getAllPHAssetFromSystem () {
        let options = PHFetchOptions()
        let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
        assetsFetchResults.enumerateObjects { (asset, index, stop) in
            let assetModel = RMAssetModel()
            assetModel.asset = asset
            self.dataSource.append(assetModel)
           
        }
        self.collectionView.reloadData()
    }
    
    func getImageFromPHAsset(assetModel:RMAssetModel, size:CGSize,cell:RMPhotoCollectionViewCell) -> Void {
//        var requestID:PHImageRequestID = -2
//        let scale:CGFloat = CGFloat(UIScreen.main.scale)
//        let width:CGFloat = CGFloat(min(size.width,500))
//        if requestID >= -1 && size.width/width == scale {
//            PHCachingImageManager.default().cancelImageRequest(requestID)
//        }
        
        let option:PHImageRequestOptions = PHImageRequestOptions()
        option.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        option.resizeMode = PHImageRequestOptionsResizeMode.fast
        if let asset = assetModel.asset{
            PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: size.width, height: size.height), contentMode: PHImageContentMode.aspectFill, options: option) { (image, _) in
                if let image = image{
                    cell.photoImageView.image =  image
                    assetModel.image = image
                }
            }
        }
        
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
