//
//  YoutubeSearchResponse.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 17.05.2023.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
