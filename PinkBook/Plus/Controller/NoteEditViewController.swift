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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var textView: LimitedTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var subChannelLabel: UILabel!
    @IBOutlet weak var channelIconImageView: UIImageView!
    @IBOutlet weak var adressIconImageView: UIImageView!
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var draftButton: UIButton!
    @IBOutlet weak var postNoteButton: UIButton!
    ///图片
    var photos = [
        UIImage(named: "2")!,
        UIImage(named: "3")!,
    ]
    var videoURL: URL?
    var isVideo: Bool { videoURL != nil }
    var dragIndexPath = IndexPath(item: 0, section: 0)
    var textViewIAView: TextViewIAView { textView.inputAccessoryView as! TextViewIAView }
    ///话题标签
    var channel = "no channel"
    ///话题内容
    var subChannel = "no subChannel"
    ///地址
    var POIName = ""
    
    let locationManager = CLLocationManager()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        postNoteButton.layer.cornerRadius = 22

        locationManager.requestWhenInUseAuthorization()
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dragInteractionEnabled = true
        
        titleCountLabel.isHidden = true
        //当在滚动视图中开始拖动时，系统取消键盘的方式。
        scrollView.keyboardDismissMode = .onDrag
        titleTextField.delegate = self
        
        hideKeyboardOnTapped()
        
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.placeholder = "添加文本"
        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", type: TextViewIAView.self)
        textViewIAView.doneButton.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
        textViewIAView.textCountStackView.isHidden = true
        textViewIAView.maxCountLabel.text = "/\(kMaxNoteEditTextViewCount)"
        textView.delegate = self
        
        //sandbox的总路径
        print(NSHomeDirectory())
        //文件的路径
        //print(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])
        //文件的url
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        
    }
    
    @IBAction func TextFieldEditDidBegin(_ sender: Any) {
        titleCountLabel.isHidden = false
    }
    @IBAction func TextFieldEditDidEnd(_ sender: Any) {
        titleCountLabel.isHidden = true
    }
    @IBAction func TextFieldDidEndExit(_ sender: Any) {
    }
    @IBAction func TextFieldEditChanged(_ sender: Any) {
        guard titleTextField.markedTextRange == nil else { return }
        if titleTextField.unwrappedText.count > kMaxNoteEditTitleCount {
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteEditTitleCount))
            HUD.show("最多只能输入\(kMaxNoteEditTitleCount)字")
            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        titleCountLabel.text = String(kMaxNoteEditTitleCount - titleTextField.unwrappedText.count)
    }
    
    //TODO
    @IBAction func draftButton(_ sender: Any) {
        
        guard textViewIAView.currentTextCount <= kMaxNoteEditTextViewCount else {
            
            HUD.show("正文最多只能输入\(kMaxNoteEditTextViewCount)字")
            return
        }
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let draftNote = DraftNote(context: context)
        
        if isVideo {
            draftNote.video = try? Data(contentsOf: videoURL!)
        }
        draftNote.coverPhoto = photos[0].jpeg(jpegQuqlity: .high)
        //draftNote.photos =
        
        var encodePhotos: [Data] = []
        for photo in self.photos {
            if let pngData = photo.pngData() {
                encodePhotos.append(pngData)
            }
        }
        draftNote.photos = try? JSONEncoder().encode(encodePhotos)
        
        draftNote.title = self.titleTextField.exactText
        draftNote.text = self.textView.exactText
        draftNote.channel = self.channel
        draftNote.subChannel = self.subChannel
        draftNote.poiName = self.POIName
        draftNote.upDateAt = Date()
        
        appDelegate.saveContext()
    }
    
    @IBAction func postNoteButton(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? ChannelViewController {
            self.view.endEditing(true)
            
        } else if let vc = segue.destination as? POIViewController {
            vc.delegate = self
            vc.poiName = POIName
        }

    }


}

//extension NoteEditViewController: ChannelViewControllerDelegate {
//    func updateChannel(channel: String, subChannel: String) {
//        self.channel = channel
//        self.subChannel = subChannel
//
//        channelLabel.text = subChannel
//        channelLabel.textColor = .mainColor
//        subChannelLabel.isHidden = true
//    }
//
//
//}

extension NoteEditViewController: POIViewControllerDelegate {
    func updatePOIName(name: String) {
        
        if POIName == kPOIs[0][0] {
            self.POIName = ""
            self.adressIconImageView.tintColor = .label
            self.adressLabel.text = "添加地点"
            self.adressLabel.textColor = .label
        } else {
            self.POIName = name
            self.adressLabel.text = self.POIName
            self.adressLabel.textColor = .mainColor
            self.adressIconImageView.tintColor = .mainColor
        }
                
    }
    
    
}

//MARK:  UICollectionViewDataSource
extension NoteEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNoteEditCellID, for: indexPath) as! NoteEditCell
        
        cell.imageView.image = photos[indexPath.item]
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isVideo {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(url: Bundle.main.url(forResource: "", withExtension: "")!)
            present(playerVC, animated: true) {
                playerVC.player?.play()
            }
            
        } else {
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

            
            present(browser, animated: true, completion: nil)
 
        }
    }
    
}

//MARK: UICollectionViewDragDelegate UICollectionViewDropDelegate
extension NoteEditViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        //dragIndexPath = indexPath
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: photos[indexPath.item]))
        dragItem.localObject = photos[indexPath.item]
        
        return [dragItem]
        //itemForAddingTo 拖拽多个 实现dragPreviewParamtersForItemAt方法
    }
    
    //正在拖拽
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        //if dragIndexPath.section == destinationIndexPath?.section {}
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        if coordinator.proposal.operation == .move, let item = coordinator.items.first, let index = item.sourceIndexPath {
            
            //将多个插入、删除、重新加载和移动操作作为一个组进行动画化。
            collectionView.performBatchUpdates {
                let dragItem = coordinator.items.first?.dragItem.localObject
                photos.remove(at: index.item)
                photos.insert(dragItem as! UIImage, at: coordinator.destinationIndexPath!.item)
                collectionView.moveItem(at: index, to: coordinator.destinationIndexPath!)
            }
            coordinator.drop(item.dragItem, toItemAt: coordinator.destinationIndexPath!)
        }
    }
    
    
}
 
extension NoteEditViewController: SKPhotoBrowserDelegate {
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        photos.remove(at: index)
        collectionView.reloadData()
        reload()
    }
}

//MARK: UITextFieldDelegate
extension NoteEditViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if range.location >= kMaxNoteEditTitleCount || (textField.unwrappedText.count + string.count) > kMaxNoteEditTitleCount {
//            HUD.show("最多只能输入\(kMaxNoteEditTitleCount)字")
//            return false
//        } else {
//            return true
//        }
//    }
}


//MARK: objc
extension NoteEditViewController {
    
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
    
    @objc func resignTextView() {
        textView.resignFirstResponder()
    }
}

//MARK: UITextViewDelegate
extension NoteEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        textViewIAView.currentTextCount = textView.text.count
    }
}
