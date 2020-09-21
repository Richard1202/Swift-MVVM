//
//  User.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/27.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit
import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let name: String?
    let role: String
    let preferWorkHours: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case name = "name"
        case role = "role"
        case preferWorkHours = "prefer_work_hours"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        email = try values.decode(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        role = try values.decode(String.self, forKey: .role)
        preferWorkHours = try values.decode(Int.self, forKey: .preferWorkHours)
    }
}
