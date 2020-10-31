//
//  PassNinjaModel.swift
//  PassNinja
//
//  Created by Sagar Radadiya on 26/10/20.
//  Copyright © 2020 Flomio. All rights reserved.
//

import Foundation

public struct PassNinjaError : Codable {
    
    let message : String?
    let statusCode : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case statusCode = "StatusCode"
    }
    
    init(message: String, statusCode: Int) throws {
        self.message = message
        self.statusCode = statusCode
    }
}

public struct PassRequest : Codable {
    let passType : String
    let serialNumber: String?
    let pass : CreatePass?
    
    init(passType: String, pass: CreatePass, serialNumber: String? = nil) {
        self.passType = passType
        self.pass = pass
        self.serialNumber = serialNumber
    }
}

public struct CreatePass : Codable {
    let logoText : String?
    let organizationName : String?
    let description : String?
    let expiration : String?
    let memberName : String?
    let specialOffer : String?
    let loyaltyLevel : String?
    let barcode : String?
    
    public init(logoText: String, organizationName: String, description: String, expiration: String, memberName: String, specialOffer: String, loyaltyLevel: String, barcode: String) {
        self.logoText = logoText
        self.organizationName = organizationName
        self.description = description
        self.expiration = expiration
        self.memberName = memberName
        self.specialOffer = specialOffer
        self.loyaltyLevel = loyaltyLevel
        self.barcode = barcode
    }
}

public struct Pass : Codable {
    
    let pass : PassResponse?
    let passType : String?
    let serialNumber : String?
    let urls : PassUrl?
    
    enum CodingKeys: String, CodingKey {
        case pass = "pass"
        case passType = "passType"
        case serialNumber = "serialNumber"
        case urls = "urls"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pass = try values.decodeIfPresent(PassResponse.self, forKey: .pass)
        passType = try values.decodeIfPresent(String.self, forKey: .passType)
        serialNumber = try values.decodeIfPresent(String.self, forKey: .serialNumber)
        urls = try values.decodeIfPresent(PassUrl.self, forKey: .urls)
    }
    
}

public struct PassUrl : Codable {
    
    let apple : String?
    let google : String?
    let landing : String?
    
    enum CodingKeys: String, CodingKey {
        case apple = "apple"
        case google = "google"
        case landing = "landing"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        apple = try values.decodeIfPresent(String.self, forKey: .apple)
        google = try values.decodeIfPresent(String.self, forKey: .google)
        landing = try values.decodeIfPresent(String.self, forKey: .landing)
    }
    
}

public struct PassResponse : Codable {
    
    let barcode : String?
    let descriptionField : String?
    let expiration : String?
    let logoText : String?
    let loyaltyLevel : String?
    let memberName : String?
    let organizationName : String?
    let specialOffer : String?
    
    enum CodingKeys: String, CodingKey {
        case barcode = "barcode"
        case descriptionField = "description"
        case expiration = "expiration"
        case logoText = "logoText"
        case loyaltyLevel = "loyaltyLevel"
        case memberName = "memberName"
        case organizationName = "organizationName"
        case specialOffer = "specialOffer"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        barcode = try values.decodeIfPresent(String.self, forKey: .barcode)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        expiration = try values.decodeIfPresent(String.self, forKey: .expiration)
        logoText = try values.decodeIfPresent(String.self, forKey: .logoText)
        loyaltyLevel = try values.decodeIfPresent(String.self, forKey: .loyaltyLevel)
        memberName = try values.decodeIfPresent(String.self, forKey: .memberName)
        organizationName = try values.decodeIfPresent(String.self, forKey: .organizationName)
        specialOffer = try values.decodeIfPresent(String.self, forKey: .specialOffer)
    }
    
}
