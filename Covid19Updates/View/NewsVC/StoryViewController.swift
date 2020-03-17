//
//  StoryViewController.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import UIKit
import WebKit

class StoryViewController: UIViewController{
    
    var storyURL : URL?

    @IBOutlet weak var newsView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = URLRequest(url: storyURL!)
        
        if let reachability = Reachability(), !reachability.isReachable{
            request.cachePolicy = .returnCacheDataDontLoad
            present(SupportViews.CreatNetworkAlert(), animated: true, completion: nil)
        }
        
        newsView.navigationDelegate = self
        newsView.frame = self.view.bounds
        newsView.load(request)
        newsView.autoresizingMask = .flexibleWidth

    }
}




//MARK:- WKNavigationDelegate to indicate loading

extension StoryViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.isHidden = true
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
}
