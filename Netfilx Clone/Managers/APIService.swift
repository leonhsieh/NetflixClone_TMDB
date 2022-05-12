//
//  APIService.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/1.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

struct Constants {
    static let API_KEY = "2be61662c9239eeffebf7aec5ef94ef8"
    static let baseURL = "https://api.themoviedb.org"
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
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trendingMovie)\(Constants.API_KEY)") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do{
                //JSONSerialization僅作測試用API連線用
//                let result = try JSONSerialization.jsonObject(with: safeData, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: safeData)
                print(results.results[0].original_title)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
             }
        }
        task.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[TV], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trendingTV)\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do {
//                let result = try JSONSerialization.jsonObject(with: safeData, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode(TrendingTVResponse.self, from: safeData)
                print(results)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getUpComingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.upComing)\(Constants.API_KEY)&language=en-US&page=1&region=us") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: safeData)
                print( results)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: safeData)
                print(results)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(compeletion: @escaping (Result<[Movie],Error>)-> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: safeData)
                print(results)
            }catch{
                compeletion(.failure(error))
            }
        }
        task.resume()
    }
}

