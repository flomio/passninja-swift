//
//  PassNinjaModel.swift
//  PassNinja
//
//  Created by Sagar Radadiya on 26/10/20.
//  Copyright © 2020 Flomio. All rights reserved.
//

import Foundation

public struct Pass : Codable {
    
    public let id : String?
    public let name : String?
    public let passTypeId : String?
    public let platform : String?
    public let style : String?
    public let issuedPassCount : Int?
    public let installedPassCount : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case passTypeId = "pass_type_id"
        case platform = "platform"
        case style = "style"
        case issuedPassCount = "issued_pass_count"
        case installedPassCount = "installed_pass_count"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        passType = try values.decodeIfPresent(String.self, forKey: .passType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        passTypeId = try values.decodeIfPresent(String.self, forKey: .passTypeId)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        style = try values.decodeIfPresent(String.self, forKey: .style)
        issuedPassCount = try values.decodeIfPresent(Int.self, forKey: .issuedPassCount)
        installedPassCount = try values.decodeIfPresent(Int.self, forKey: .installedPassCount)
    }
}