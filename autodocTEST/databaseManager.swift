//
//  databaseManager.swift
//  autodocTEST
//
//  Created by Руслан Сидоренко on 26.06.2024.
//

import Foundation

class databaseManager {
    
    static let shared = databaseManager()
    
    init(){}
    
    func getNews(completion: @escaping ([postModel]) -> Void
    ){
        guard let url = URL(string: "https://webapi.autodoc.ru/api/news/1/15") else {
            print("failed URL string address")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil, response != nil, error == nil else {
                print("failed to download data from url")
                return
            }
            let stringData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            let stringDataPost = stringData as! [String: Any]
            
            let news = stringDataPost["news"] as! [[String: Any]]
            
            let posts: [postModel] = news.compactMap { stroke in
                guard let title = stroke["title"] as? String,
                      let titleImageUrl = stroke["titleImageUrl"] as? String?,
                      let description = stroke["description"] as? String,
                      let fullUrl = stroke["fullUrl"] as? String?
                      else {
                    print("invalid news post fetching")
                    return nil
                }
               
                let post = postModel(title: title, description: description, fullURL: fullUrl, titleImageUrl: titleImageUrl)
                
                return post
            }
            completion(posts)
        }
        task.resume()
    }
}
