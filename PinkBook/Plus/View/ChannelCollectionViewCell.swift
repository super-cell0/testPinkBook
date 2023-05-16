//
//  ChannelCollectionViewCell.swift
//  PinkBook
//
//  Created by mac on 2023/5/15.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let lineView = UIView()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontForContentSizeCategory = true
        contentView.addSubview(titleLabel)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .opaqueSeparator
        contentView.addSubview(lineView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 14),
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
