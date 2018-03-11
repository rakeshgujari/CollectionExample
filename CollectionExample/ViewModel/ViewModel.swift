//
//  ViewModel.swift
//  ArchitecturalDemo
//
//  Created by Rakesh on 2/3/18.
//  Copyright © 2017 Rakesh Gujari. All rights reserved.
//

import UIKit

class ViewModel: NSObject {

    private override init() {}
    public static let `default` = ViewModel()
    
    ///Holds data
    var movies : [Movie] = []
    var totalMoviesCount : Int?
    var pageNumber : Int = 1
    var movieData: NSDictionary?
    
    /// Trigerrs network manager to get movies from server
    ///
    /// - Parameter completionHandler: throws response back to calling controller
    func getMovies(searchStr: String, urlStr: String? = nil, completionHandler: @escaping (Bool) -> Void) {
        
        if !AppHelper.context.isConnectedToNetwork() {
            completionHandler(false)
            return
        }
        var pathParam = String(format:Constants.URL.getMoviesList,searchStr,pageNumber)
        if urlStr != nil {
            pathParam = String(format: urlStr!,pageNumber)
        }
        
        NetworkManager.context.getDataFromServer(Constants.URL.baseURL+pathParam) { (data,status) in
            if data != nil {
                self.totalMoviesCount = (data?.value(forKey: "total_results") as? NSNumber ?? 0).intValue
                
                
                if let moviesData = data?.value(forKey: "results") as? [NSDictionary] {
                    
                    for i in 0..<moviesData.count {
                        let model = Movie()
                        model.title = moviesData[i].object(forKey: "title") as? String ?? ""
                        model.poster = moviesData[i].object(forKey: "poster_path") as? String ?? ""
                        model.id = moviesData[i].object(forKey: "id") as? NSNumber ?? 0
                        self.movies.append(model)
                    }
                    if (moviesData.count==20) {
                        self.pageNumber+=1
                    }
                    completionHandler(true)
                    return
                }
            }
            completionHandler(false)
        }
    }
    
    func getMovieInfo(id : String,completionHandler: @escaping (Bool) -> Void) {
        if !AppHelper.context.isConnectedToNetwork() {
            completionHandler(false)
            return
        }
        
        let pathParam = String(format:Constants.URL.getMovieInfo,id)
        NetworkManager.context.getDataFromServer(Constants.URL.baseURL+pathParam) { (response, status) in
            if(response != nil && status == "SUCCESS") {
                self.movieData = response!
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
        
    }
    
    
}
