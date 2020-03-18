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
    var pageNumber : Int = 0
    var errorCount = 0
    
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
        self.viewModel.fetchData(fromPage: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadingNews), name: Notification.Name("loadingNews"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.newsLoaded), name: Notification.Name("newsLoaded"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.newsError), name: Notification.Name("errorLoading"), object: nil)
        if let reachability = Reachability(), !reachability.isReachable{            
            present(SupportViews.CreatNetworkAlert(), animated: true, completion: nil)
        }
    }
    @objc func loadingNews(notification: Notification) {
        removeSpinner()
        showSpinner(onView: collectionView)
    }
    @objc func newsLoaded(notification: Notification) {
           removeSpinner()
       }
    @objc func newsError(notification: Notification) {
        if errorCount < 3 {
            self.showMessage(title: "Can't get the news",
                             message: "Please try a different region")
        } else {
        self.showMessage(title: "Can't update the data",
                  message: "Please make sure you're connected to the internet.")
        removeSpinner()
        }
    }
}

var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
        }
    }
}




