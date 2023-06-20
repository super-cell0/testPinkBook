//
//  ListContainerViewController.swift
//  PinkBook
//
//  Created by mac on 2023/4/24.
//

import UIKit
import JXSegmentedView
import CHTCollectionViewWaterfallLayout
import CoreData

private let kReuseIdentifier = "waterfallID"
private let kDraftNoteIdentifier = "DraftNoteIdentifier"

class ListContainerViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(ListContainerCollectionViewCell.self, forCellWithReuseIdentifier: kReuseIdentifier)
        c.register(DraftNoteCollectionViewCell.self, forCellWithReuseIdentifier: kDraftNoteIdentifier)
        return c
    }()
    
    let photos = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!,
        UIImage(named: "9")!,
        UIImage(named: "10")!,
        UIImage(named: "11")!,
        UIImage(named: "12")!,
        UIImage(named: "13")!,
        UIImage(named: "14")!,
        UIImage(named: "15")!,
        UIImage(named: "16")!,
        UIImage(named: "17")!,
        UIImage(named: "18")!,
        UIImage(named: "19")!,
        UIImage(named: "cqs")!,
    ]
    
    var isDraft = true
    var draftNotes: [DraftNote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        getDraftNotes()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func setupView() {
        super.setupView()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

        ])
        
    }
    
    override func bindView() {
        super.bindView()
        
        collectionView.collectionViewLayout = CHTCollectionViewWaterfallLayout()
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 2
        layout.minimumColumnSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.itemRenderDirection = .leftToRight
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }

}

extension ListContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDraft {
            return draftNotes.count
        } else {
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isDraft {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftNoteIdentifier, for: indexPath) as! DraftNoteCollectionViewCell
            
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.opaqueSeparator.cgColor
            cell.contentView.layer.cornerRadius = 5
            cell.draftNote = self.draftNotes[indexPath.item]
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseIdentifier, for: indexPath) as! ListContainerCollectionViewCell
            
            cell.imageView.image = photos[indexPath.item]
            
            return cell

        }
    }
    
    
}

extension ListContainerViewController {
    func getDraftNotes() {
        let appDeleagte = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleagte.persistentContainer.viewContext
        
        let draftNotes = try! context.fetch(DraftNote.fetchRequest() as NSFetchRequest<DraftNote>)
        self.draftNotes = draftNotes
    }
}

extension ListContainerViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photos[indexPath.item].size
    }
    
    
}

extension ListContainerViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    
}
