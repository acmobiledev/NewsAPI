//
//  NewsTableViewCell.swift
//  NewsAPI
//
//  Created by Amit Chaudhary on 11/28/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit

enum CellState {
  case expanded
  case collapsed
}

class NewsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    //TitleLabel
    var titleLabel: UILabel = {
        let newsTitle = UILabel()
        newsTitle.numberOfLines = 5
        newsTitle.textColor = .systemPurple
        newsTitle.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return newsTitle
    }()
    
    //timeLabel
    var dateAndTimeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.numberOfLines = 0
        timeLabel.textColor = .systemBlue
//        timeLabel.backgroundColor = .systemPink
        return timeLabel
    }()
    
    // newsImageView
    var newsImageView: UIImageView = {
        let newsIMV = UIImageView()
        newsIMV.contentMode = .scaleAspectFill
        newsIMV.clipsToBounds = true
        newsIMV.backgroundColor = .systemIndigo
        return newsIMV
    }()
    
    // descriptionLabel
    var descriptionLabel: UILabel = {
        let descriptionL = UILabel()
        descriptionL.numberOfLines = 0
        descriptionL.textColor = .systemGreen
//        descriptionL.backgroundColor = .orange
        return descriptionL
    }()
    
    
    //MARK: - Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.layoutComponentsOfCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutComponentsOfCell() {
            
            self.addSubview(newsImageView)
        newsImageView.anchorView(top: self.topAnchor, left: self.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topPadding: 10, leftPadding: 10, bottomPadding: 0, rightPadding: 0, width: 80, height: 80)
            newsImageView.layer.cornerRadius = 80 / 2
            
            self.addSubview(titleLabel)
        titleLabel.anchorView(top: self.topAnchor, left: self.newsImageView.rightAnchor, bottom: self.bottomAnchor, right: self.safeAreaLayoutGuide.rightAnchor, topPadding: 10, leftPadding: 20, bottomPadding: 10, rightPadding: 12, width: 0, height: 00)
        
        
            self.addSubview(dateAndTimeLabel)
        dateAndTimeLabel.anchorView(top: self.newsImageView.bottomAnchor, left: self.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: self.titleLabel.leftAnchor, topPadding: 10, leftPadding: 10, bottomPadding: 0, rightPadding: 12, width: 0, height: 00)
        
        
            self.addSubview(descriptionLabel)
        descriptionLabel.anchorView(top: self.dateAndTimeLabel.bottomAnchor, left: self.safeAreaLayoutGuide.leftAnchor, bottom: self.bottomAnchor, right: self.titleLabel.leftAnchor, topPadding: 8, leftPadding: 10, bottomPadding: 20, rightPadding: 12, width: 0, height: 00)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       // self.newsImageView.image = nil
    }
    
    
    
}
