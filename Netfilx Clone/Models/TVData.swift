//
//  TVData.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/12.
//

import Foundation

struct TrendingTVResponse:Codable {
    let results:[TV]
}

struct TV: Codable {
    let first_air_date: String?
    let id: Int
    let name: String?
    let original_language: String?
    let overview: String?
    let poster_path: String?
    let vote_average: Double
    let vote_count: Int
}
