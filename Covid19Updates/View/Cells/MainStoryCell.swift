//
//  NewsCell.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import UIKit

class MainStoryCell: UICollectionViewCell, ConfigurableCell {
    
    @IBOutlet weak var image: CustomImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var source: UILabel!
    
    var newsModel : NewsItemViewModel? 

    func configureCell(with data: NewsItemViewModel) {
        
        newsModel = data
        self.newsDescription.text = newsModel?.storyDescription()
        self.source.text = newsModel?.sourceName()
        self.timeLabel.text = newsModel?.time()
        newsModel?.storyImage(imageView: self.image)
        
        if ((newsModel?.title().isEmpty)!){
            self.title.text = "Top News"
        }else{
            self.title.text = newsModel?.title()
        }
    }
    
}
