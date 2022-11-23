//
//  BeerListCell.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/18.
//

import UIKit
import SnapKit
import Kingfisher
import Lottie

class BeerListCell: UITableViewCell {
    
    let beerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        return label
    }()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

extension BeerListCell {
    private func setupLayout() {
        
        [beerImageView, nameLabel, taglineLabel].forEach {
            contentView.addSubview($0)
        }
        
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(with beer: Beer) {
        let imageURL = URL(string: beer.imageURL ?? "")
        beerImageView.kf.setImage(with: imageURL, placeholder: UIImage(named:"drink")
                                  //,options: [.transition(.fade(0.5)),  .forceTransition]
        )
        nameLabel.text = beer.name ?? "알 수 없는 맥주"
        taglineLabel.text = beer.tagLine
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
}
