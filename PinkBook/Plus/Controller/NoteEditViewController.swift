//
//  NoteEditViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/5.
//

import UIKit
import YPImagePicker
import AVKit
import MBProgressHUD
import SKPhotoBrowser

class NoteEditViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func setupView() {
        
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

extension NoteEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNoteEditCellID, for: indexPath) as! NoteEditCell
        
        cell.imageView.image = photos[indexPath.item]
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kNoteEditReusableViewID, for: indexPath) as! NoteEditReusableView
            footer.addButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            
            return footer
        default:
            fatalError("")
        }
    }
    
    @objc func addPhoto() {
        if photos.count < kMaxPhotoCount {
            var config = YPImagePickerConfiguration()
            //通用配置
            config.usesFrontCamera = false
            config.showsPhotoFilters = true
            config.showsVideoTrimmer = true
            config.shouldSaveNewPicturesToAlbum = true
            config.albumName = Bundle.main.appName
            config.screens = [.library]
            
            //相册配置
            config.library.options = nil
            config.library.onlySquare = false
            config.library.isSquareByDefault = true
            config.library.minWidthForItem = nil
            config.library.mediaType = YPlibraryMediaType.photoAndVideo
            //多选
            config.library.defaultMultipleSelection = true
            config.library.maxNumberOfItems = kMaxPhotoCount - photos.count
            config.library.minNumberOfItems = 1
            config.library.numberOfItemsInRow = 4
            config.library.spacingBetweenItems = 1.0
            config.library.skipSelectionsGallery = false
            config.library.preselectedItems = nil
            config.library.preSelectItemOnMultipleSelection = false
            
            //视频配置
            config.video.compression = AVAssetExportPresetHighestQuality
            config.video.fileType = .mov
            config.video.recordingTimeLimit = 60.0
            config.video.libraryTimeLimit = 60.0
            config.video.minimumTimeLimit = 3.0
            config.video.trimmerMaxDuration = 60.0
            config.video.trimmerMinDuration = 3.0
            
            config.gallery.hidesRemoveButton = false

            
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, _ in
                
                for item in items {
                    if case let .photo(photo) = item {
                        self.photos.append(photo.image)
                    }
                }
                //调用过后会从新加载UICollectionViewDataSource
                self.collectionView.reloadData()
                
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)

        } else {
            HUD.show("最多只能选择9张图片或者视频")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. create SKPhoto Array from UIImage
        var images: [SKPhoto] = []
        for photo in photos {
            let newPhoto = SKPhoto.photoWithImage(photo)
            images.append(newPhoto)
        }
        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        browser.initializePageIndex(indexPath.item)
        //browser.updateDeleteButton(UIImage(systemName: "trash")!, size: CGSize(width: 20, height: 20))
        SKPhotoBrowserOptions.displayDeleteButton = true
        SKPhotoBrowserOptions.backgroundColor = .white
        
        present(browser, animated: true, completion: nil)
    }
    
}
 
extension NoteEditViewController: SKPhotoBrowserDelegate {
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        photos.remove(at: index)
        collectionView.reloadData()
        reload()
    }
}
