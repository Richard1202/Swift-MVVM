//
//  Task.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/31.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

struct Task: Codable {
    let id: Int
    let userId: Int
    let title: String
    let description: String
    let date: String
    let hours: Int
    let prefer: Int?
    let userName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case title = "title"
        case description = "description"
        case date = "date"
        case hours = "hours"
        case prefer = "prefer"
        case userName = "user_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        userId = try values.decode(Int.self, forKey: .userId)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        date = try values.decode(String.self, forKey: .date)
        hours = try values.decode(Int.self, forKey: .hours)
        prefer = try values.decodeIfPresent(Int.self, forKey: .prefer)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
    }
}
