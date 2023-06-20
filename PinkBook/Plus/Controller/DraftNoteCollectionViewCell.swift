//
//  DraftNoteCollectionViewCell.swift
//  PinkBook
//
//  Created by mac on 2023/6/16.
//

import UIKit

class DraftNoteCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    lazy var channelLabel: UILabel = {
        let c = UILabel()
        c.text = "今天在干嘛呢"
        c.font = .myFont(ofSize: 14, weight: .regular)
        c.textColor = .label
        return c
    }()
    
    lazy var dateLabel: UILabel = {
       let d = UILabel()
        d.text = "06-20"
        d.font = .myFont(ofSize: 12, weight: .regular)
        d.textColor = .secondaryLabel
        return d
    }()
    
    lazy var trashButton: UIButton = {
       let t = UIButton()
        t.setImage(UIImage(systemName: "trash"), for: .normal)
        t.configuration?.buttonSize = .small
        t.tintColor = .secondaryLabel
        return t
    }()
    
    lazy var hStackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [dateLabel, trashButton])
        s.axis = .horizontal
        s.distribution = .equalSpacing
        s.alignment = .fill
        s.spacing = 0
        return s
    }()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [channelLabel, hStackView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    var draftNote: DraftNote? {
        didSet {
            guard let draftNote = draftNote else { return }
            channelLabel.text = draftNote.channel!.isEmpty ? "无题" : draftNote.channel!
            imageView.image = UIImage(data: draftNote.coverPhoto) ?? UIImage(named: "cqs")
            dateLabel.text = draftNote.upDateAt?.formattedDate
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            //imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            vStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
