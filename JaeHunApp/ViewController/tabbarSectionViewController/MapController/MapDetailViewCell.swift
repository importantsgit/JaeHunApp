//
//  MapDetailViewCell.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/18.
//

import UIKit

import UIKit
import SnapKit
import Kingfisher

class MapDetailViewCell: UITableViewCell {
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageView, nameLabel, taglineLabel].forEach {
            contentView.addSubview($0)
        }
        
        beerImageView.contentMode = .scaleAspectFit
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2
        
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        taglineLabel.textColor = .systemGray
        taglineLabel.numberOfLines = 0
        
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(64)
            $0.height.equalTo(64)
            $0.leading.equalToSuperview().inset(16)

        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(16)
            $0.bottom.equalTo(beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(with artwork: Artwork) {
        beerImageView.image = artwork.image
        beerImageView.image = beerImageView.image?.withRenderingMode(.alwaysTemplate)
        beerImageView.tintColor = artwork.markerTintColer
//        let url = URL(string: artwork.imagefile ?? "")
//        beerImageView.kf.setImage(with: url)
        nameLabel.text = artwork.title
        taglineLabel.text = artwork.description
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
}
