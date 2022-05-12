//
//  MovieData.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/11.
//

import Foundation

struct TrendingMovieResponse:Codable {
    let results:[Movie]
}

struct Movie:Codable {
    let id: Int
    let media_type: String?//使用optional，以免nil造成崩潰
    let original_language: String?
    let original_title: String?
    let title: String?
    let poster_path: String?
    let overview: String?
    let vote_average: Double
    let vote_count: Int
    let release_date: String?
    
}


