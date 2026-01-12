//
//  TikTokPost.swift
//  TikSavePro
//
//  Created by Bhautik Patoliya on 06/01/26.
//

import UIKit

struct TikTokPost: Codable {
    let id: String
    let desc: String
    let createTime: String
    let video: Video
    let author: Author
    let stats: Stats
    let locationCreated: String?
}

struct Video: Codable {
    let duration: Int
    let ratio: String
    let cover: String
    let playAddr: String
    let downloadAddr: String
    let bitrate: Int
}

struct Author: Codable {
    let id: String
    let uniqueId: String
    let nickname: String
    let avatarLarger: String
    let signature: String?
    let verified: Bool
}

struct Stats: Codable {
    let diggCount: Int
    let shareCount: Int
    let commentCount: Int
    let playCount: Int
}
