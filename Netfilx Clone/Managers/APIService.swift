//
//  APIService.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/1.
//

import Foundation
import UIKit

enum APIError: Error {
    case failedToGetData
}

struct Constants {
    static let TMDBAPI_KEY = "2be61662c9239eeffebf7aec5ef94ef8"
    static let TMDBbaseURL = "https://api.themoviedb.org"
    static let YoutubeDataAPI_KEY = "AIzaSyCxWsUM_Bz0Vpz4dk7pn9UxnCq4LlyPbVI"
    static let YoutubeDataBaseURL = "https://youtube.googleapis.com/youtube/v3"

}

struct YoutubeRequests {
    static let YTsearch = "/search?q="
}

struct TMDBRequests {
    static let trendingMovie =  "/3/trending/movie/day?api_key="
    static let trendingTV = "/3/trending/tv/day?api_key="
    static let upComing = "/3/movie/upcoming?api_key="
    //    static let APIversion = "3/"
    //    static let APIrequestMethod = "trending/"
    static let mediaTypeAll = "all"
    static let mediaTypeMovie = "movie"
    static let mediaTypeTV = "tv"
    static let timeWindowScopeInDay = "day"
}

class APIService {
    
    static let shared = APIService()//使用share方便從外部呼叫APIService()
    
    //開始fetching 資料，將原本的(String)改為Result
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TMDBbaseURL)\(TMDBRequests.trendingMovie)\(Constants.TMDBAPI_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do{
                //JSONSerialization僅作測試用API連線用
//                let result = try JSONSerialization.jsonObject(with: safeData, options: .fragmentsAllowed)
//                print(result)
                
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: safeData)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.TMDBbaseURL)\(TMDBRequests.trendingTV)\(Constants.TMDBAPI_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: safeData)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUpComingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDBbaseURL)\(TMDBRequests.upComing)\(Constants.TMDBAPI_KEY)&language=en-US&page=1") else { return }
        
        
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                guard let safeData = data, error == nil else { return }
                do {
                    let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: safeData)
                    completion(.success(results.results))
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
        

    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TMDBbaseURL)/3/movie/popular?api_key=\(Constants.TMDBAPI_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: safeData)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title],Error>)-> Void) {
        guard let url = URL(string: "\(Constants.TMDBbaseURL)/3/movie/top_rated?api_key=\(Constants.TMDBAPI_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: safeData)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title],Error>)-> Void) {
        guard let url = URL( string: "\(Constants.TMDBbaseURL)/3/discover/movie?api_key=\(Constants.TMDBAPI_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: safeData)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title],Error>)-> Void) {
        
        //format query 格式化排序
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL( string: "\(Constants.TMDBbaseURL)/3/search/movie?api_key=\(Constants.TMDBAPI_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: safeData)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //TODO:
    //如何取得預告片：TMDB影片的<id> -> GET videos <movie_id> -> 取得"type"="Trailer"的key，或影片的"name"包含"Official Trailer "
    
    func getYTMovie(with query: String, completion: @escaping (Result<VideoElement,Error>)-> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}//取代原本yt request中的%20
        
        guard let url = URL(string: "\(Constants.YoutubeDataBaseURL)\(YoutubeRequests.YTsearch)\(query)&key=\(Constants.YoutubeDataAPI_KEY)") else { return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else {return}
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: safeData)
                completion(.success(result.items[0]))

            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
//https://youtube.googleapis.com/youtube/v3/search?q=Harry%20Potter&key=[YOUR_API_KEY]

