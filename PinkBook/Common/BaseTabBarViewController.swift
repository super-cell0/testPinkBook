//
//  BaseTabBarViewController.swift
//  PinkBook
//
//  Created by mac on 2023/4/27.
//

import UIKit
import YPImagePicker
import AVKit

class BaseTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewController as? PlusViewController {
            var config = YPImagePickerConfiguration()
            //通用配置
            config.isScrollToChangeModesEnabled = false
            config.onlySquareImagesFromCamera = false
            config.usesFrontCamera = false
            config.showsPhotoFilters = true
            config.showsVideoTrimmer = true
            config.shouldSaveNewPicturesToAlbum = true
            config.albumName = Bundle.main.appName
            config.startOnScreen = YPPickerScreen.library
            config.screens = [.library, .photo, .video]
            config.showsCrop = .none
            config.targetImageSize = YPImageSize.original
            config.overlayView = UIView()
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.hidesCancelButton = false
            config.preferredStatusBarStyle = UIStatusBarStyle.default
            config.bottomMenuItemSelectedTextColour = UIColor.label
            config.bottomMenuItemUnSelectedTextColour = UIColor.mainColor
            config.maxCameraZoomFactor = 5
            
            //相册配置
            config.library.options = nil
            config.library.onlySquare = false
            config.library.isSquareByDefault = true
            config.library.minWidthForItem = nil
            config.library.mediaType = YPlibraryMediaType.photoAndVideo
            config.library.defaultMultipleSelection = false
            config.library.maxNumberOfItems = kMaxPhotoCount
            config.library.minNumberOfItems = 1
            config.library.numberOfItemsInRow = 4
            config.library.spacingBetweenItems = 1.0
            config.library.skipSelectionsGallery = false
            config.library.preselectedItems = nil
            config.library.preSelectItemOnMultipleSelection = true
            
            //视频配置
            config.video.compression = AVAssetExportPresetHighestQuality
            config.video.fileType = .mov
            config.video.recordingTimeLimit = 60.0
            config.video.libraryTimeLimit = 60.0
            config.video.minimumTimeLimit = 3.0
            config.video.trimmerMaxDuration = 60.0
            config.video.trimmerMinDuration = 3.0
            
            config.gallery.hidesRemoveButton = true

            
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, cancelled in
                
                if cancelled {
                    print("用户点击了取消")
                }
                
                for item in items {
                    switch item {
                    case let .photo(photo):
                        print(photo)
                    case let .video(video):
                        print(video)
                    }
                }
                
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
    }

}
