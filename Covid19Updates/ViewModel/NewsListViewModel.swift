//
//  VehicleListViewModel.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//
//

import Foundation


typealias NewsCellConfig = NewsCollectionCellConfigurator<NewsCell, NewsItemViewModel>
typealias MainStoryCellConfig = NewsCollectionCellConfigurator<MainStoryCell, NewsItemViewModel>

class NewsListViewModel {
    
    weak var dataSource : GenericDataSource<NewsItemViewModel>?
    weak var service : DataFetchServiceProtocol?
    
    var errorResult : ((ErrorResult?)->Void)?
    
    init(service : DataFetchServiceProtocol = NewsFetchService.shared, dataSource : GenericDataSource<NewsItemViewModel>?) {
        self.dataSource = dataSource
        self.service = service
    }
    
    
    
    func fetchData(fromPage number : Int) {
        
        guard let service = service else {
            errorResult?(ErrorResult.custom(string: "service missing"))
            return
        }
        service.fetchDatafromServer(fromPage: number) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let receivedData):
                    TotalArticleList.shared.update(with: receivedData.articleList!, totalResults: receivedData.totalArticles!)
                    self.dataSource?.data.value = TotalArticleList.shared.loadedArticleList!.compactMap(NewsItemViewModel.init)
                    
                case .failure(let error):
                    self.errorResult?(error)
                    
                }
            }
        }
        
    }
    
    
}
