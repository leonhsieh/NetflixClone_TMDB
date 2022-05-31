//
//  YoutubeSearchResponse.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/19.
//

import Foundation

struct YoutubeSearchResponse:Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let etag: String
    let id: IDVideoElement
}

struct IDVideoElement:Codable {
    let kind: String
    let videoId: String
}
