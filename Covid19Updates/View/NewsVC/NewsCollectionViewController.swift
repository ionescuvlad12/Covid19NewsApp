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
        removeSpinner { () in
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.collectionView.isScrollEnabled = false
            self.showSpinner(onView: self.collectionView)
            Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { (timer) in
                self.removeSpinner { () in
                    self.collectionView.isScrollEnabled = true
                }
        }
        
        }
    }
    @IBAction func sourceToggleDidChange(_ sender: Any) {
        if let regionControl = self.parent?.parent as? RegionController, let segmentControl = sender as? UISegmentedControl {
            let isInternational = segmentControl.selectedSegmentIndex == 1
            regionControl.service?.isInternational = isInternational
            viewModel.fetchData(fromPage: 0)
            
        }
    }
    @objc func newsLoaded(notification: Notification) {
        removeSpinner { () in
            self.errorCount = 0
            self.collectionView.isScrollEnabled = true
        }
       }
    @objc func newsError(notification: Notification) {
        if errorCount < 3 {
            self.showMessage(title: "Can't get the news",
                             message: "Please try a different region")
            errorCount += 1
        } else {
        self.showMessage(title: "Can't update the data",
                  message: "Please make sure you're connected to the internet.")
            
        }
        removeSpinner { () in
            self.collectionView.isScrollEnabled = true
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
    
    func removeSpinner(completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            completion()
        }
    }
}




