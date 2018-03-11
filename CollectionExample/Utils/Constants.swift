//
//  Constants.swift
//  ArchitecturalDemo
//
//  Created by Rakesh on 2/3/18.
//  Copyright © 2017 Rakesh Gujari. All rights reserved.
//

import UIKit

struct Constants {
    
    static let API_KEY = "2b265c95fd74045ded54df00318b9eae"
    
    struct URL {
        static let baseURL = "https://api.themoviedb.org/3/"
        static let imageEndPoint = "http://image.tmdb.org/t/p/w185/"
        static let getMoviesList = "search/movie?api_key=\(Constants.API_KEY)&language=en-US&query=%@&page=%d"
        static let getMovieInfo = "movie/%@?api_key=\(Constants.API_KEY)"
        static let getPopularMovies = "movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=%d"
        static let getTopRatedMovies = "movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=%d"
    }
    
    struct  ScreenDimensions {
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
    }
}
