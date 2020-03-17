//
//  NewsCollectionViewController.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import UIKit


class NewsCollectionViewController: UICollectionViewController {
    
    let dataSource = NewsDataSource()
    var selectedStoryURL : URL?
    var pageNumber : Int = 1
    
    lazy var viewModel : NewsListViewModel = {
        let viewModel = NewsListViewModel(dataSource: dataSource)
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        
        self.dataSource.data.addAndNotify(observer: self) {[weak self] _ in
            self?.collectionView.reloadData()
        }
        self.viewModel.fetchData(fromPage: 1)
        
        if let reachability = Reachability(), !reachability.isReachable{            
            present(SupportViews.CreatNetworkAlert(), animated: true, completion: nil)
        }
    }
}





