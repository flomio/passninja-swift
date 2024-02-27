//
//  API.swift
//  PassNinja
//
//  Created by Sagar Radadiya on 26/10/20.
//  Copyright © 2020 Flomio. All rights reserved.
//

import Foundation
import Moya

enum EndPoint{
    case createPass(pass: PassRequest)
    case getPass(passType: String, serialNumber: String)
    case putPass(pass: PassRequest)
    case deletePass(passType: String, serialNumber: String)
    case getPassTypeKeys(passType: String)
}

extension EndPoint : TargetType{
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var baseURL: URL {
        return URL(string: "https://api.passninja.com/v1")!
    }
    
    var path: String {
        switch self {
        case .getPassTemplate:
            return "/pass_templates/\(passType)"
        case .createPass:
            return "/passes"
        case .getPass(let passType, let serialNumber):
            return "/passes/\(passType)/\(serialNumber)"
        case .putPass(let pass):
            return "/passes/\(pass.passType)/\(pass.serialNumber!)"
        case .deletePass(let passType, let serialNumber):
            return "/passes/\(passType)/\(serialNumber)"
        case .getPassTypeKeys(let passType):
            return "/passtypes/keys/\(passType)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createPass:
            return .post
        case .getPass, .getPassTypeKeys, .getPassTemplate:
            return .get
        case .putPass:
            return .put
        case .deletePass:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createPass(let pass):
            if let passParams = pass.pass {
                let params = ["passType": pass.passType, "pass": passParams] as [String : Any]
                return params
            }else {
                return [:]
            }
        case .getPass(let passType, let serialNumber):
            return ["passType": passType,
                    "serialNumber": serialNumber]
        case .getPassTemplate(let passType):
            return ["passType": passType]
        case .putPass(let pass):
            if let passParams = pass.pass {
                let params = ["passType": pass.passType, "serialNumber": pass.serialNumber as Any, "pass": passParams] as [String : Any]
                return params
            }else {
                return [:]
            }
        case .deletePass(let passType, let serialNumber):
            return ["passType": passType,
                    "serialNumber": serialNumber]
        case .getPassTypeKeys:
            return nil
        }
    }
    
    var task: Task {
        switch self {
        case .createPass:
            var parameterData = Data()
            do {
                parameterData = try JSONSerialization.data(withJSONObject: parameters!, options: [])
            } catch let error {
                print("Parameters not converted with error: \(error)")
            }
            return .requestData(parameterData)
        case .putPass:
            var parameterData = Data()
            do {
                parameterData = try JSONSerialization.data(withJSONObject: parameters!, options: [])
            } catch let error {
                print("Parameters not converted with error: \(error)")
            }
            return .requestData(parameterData)
        case .getPass, .deletePass, .getPassTypeKeys, .getPassTemplate:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch  self {
        case .createPass, .getPass, .putPass, .deletePass, .getPassTypeKeys, .getPassTemplate:
            var header = ["Content-Type": "application/json"]
            header["x-account-id"] = passAccountId
            header["x-api-key"] = passApiKey
            return header
        }
    }
}
