//
//  News.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:AnyObject]
struct News{
    let source : Source
    let title : String
    let description : String
    let content : String
    let time : String
    let newsUrl : String
    let imageUrl : String

    init(dictionary:JSONDictionary) {
        
            let id = dictionary["url"] as? String
            let name = dictionary["source"]?["name"] as? String
            let title = dictionary["title"] as? String
            let slicedDesciption1 = (dictionary["description"] as? String)?.slice(from: "<div>", to: "></div>")
            let slicedDesciption2 = slicedDesciption1?.slice(from: "<div>", to: "</div")
            let description = slicedDesciption2
            let content = dictionary["content"] as? String
            let time = dictionary["date"] as? String
            let newsUrl = dictionary["url"] as? String
            let imageUrl = dictionary["enclosure"]?["url"]as? String
        
        
        self.source = Source(id: id ?? "", name: name ?? "")
        self.title = title ?? ""
        self.description = description ?? ""
        self.content = content ?? ""
        self.time = time ?? ""
        self.newsUrl = newsUrl ?? ""
        self.imageUrl = imageUrl ?? ""
    }
}

struct Source {
    let id : String
    let name : String
}

struct Articles {
    let articleList : [News]?
    let totalArticles : Int?
}

extension Articles : Parceable {
    static func parseObject(dictionary: [String : AnyObject]) -> Result<Articles, ErrorResult> {
        
        if let values = dictionary["data"] as? NSDictionary, let feed = values["createFeed"] as? NSDictionary, let count = (feed["items"] as? NSArray)?.count, let data = feed["items"] as? [[String:AnyObject]] {
            
            guard data.count > 0 else {
                return Result.failure(ErrorResult.parser(string: "No vehicle Details"))
            }
            
            var articles : [News] = []
            articles = data.compactMap(News.init)
            
            if articles.count == data.count {
                
                return Result.success(Articles(articleList: articles, totalArticles: count))
                
            }else{
                return Result.failure(ErrorResult.parser(string: "Unable to parse all Vehicle Model"))
            }
            
        } else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse Vehicle Model"))
        }
        
    }
    
}

extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
