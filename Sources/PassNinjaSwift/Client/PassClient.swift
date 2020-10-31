//
//  PassViewModel.swift
//  PassNinja
//
//  Created by Sagar Radadiya on 26/10/20.
//  Copyright © 2020 Flomio. All rights reserved.
//

import Foundation
import Moya
import Alamofire

public class PassClient {
    
    let provider = MoyaProvider<EndPoint>()
    
    public func createPass(pass: PassRequest, onSuccess: @escaping (_ response: Pass) -> Void, onError: @escaping (_ error: PassNinjaError?) -> Void) {
        let isValidRequest = validatePass(passType: pass.passType, endPointType: .Create)
        var error: PassNinjaError?
        if let message = checkMissingAccountIdanApiKey() {
            error = try! PassNinjaError(message: message, statusCode: 500)
        }else if !isValidRequest{
            error = try! PassNinjaError(message: "Please enter a valid pass type", statusCode: 500)
        }else {
            provider.request(.createPass(pass: pass)) { result in
                switch result{
                case .success(let response):
                    do {
                        print(try response.mapJSON())
                        if response.statusCode == 200 {
                            let pass = try JSONDecoder().decode(Pass.self, from: response.data)
                            onSuccess(pass)
                        } else {
                            let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                            onError(error)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    public func getPass(passType: String, serialNumber: String, onSuccess: @escaping (_ response: Pass) -> Void, onError: @escaping (_ error: PassNinjaError?) -> Void) {
        let isValidRequest = validatePass(passType: passType, serialNumber: serialNumber, endPointType: .Get)
        var error: PassNinjaError?
        if let message = checkMissingAccountIdanApiKey() {
            error = try! PassNinjaError(message: message, statusCode: 500)
        }else if !isValidRequest{
            error = try! PassNinjaError(message: "Please enter a valid pass type and serial number", statusCode: 500)
        }else {
            provider.request(.getPass(passType: passType, serialNumber: serialNumber)) { result in
                switch result{
                case .success(let response):
                    do {
                        print(try response.mapJSON())
                        if response.statusCode == 200 {
                            let pass = try JSONDecoder().decode(Pass.self, from: response.data)
                            onSuccess(pass)
                        } else {
                            let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                            onError(error)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    public func putPass(pass: PassRequest, onSuccess: @escaping (_ response: Pass) -> Void, onError: @escaping (_ error: PassNinjaError?) -> Void) {
        let isValidRequest = validatePass(passType: pass.passType, endPointType: .Put)
        var error: PassNinjaError?
        if let message = checkMissingAccountIdanApiKey() {
            error = try! PassNinjaError(message: message, statusCode: 500)
        }else if !isValidRequest{
            error = try! PassNinjaError(message: "Please enter a valid pass type and serial number", statusCode: 500)
        }else {
            provider.request(.putPass(pass: pass)) { result in
                switch result{
                case .success(let response):
                    do {
                        print(try response.mapJSON())
                        if response.statusCode == 200 {
                            let pass = try JSONDecoder().decode(Pass.self, from: response.data)
                            onSuccess(pass)
                        } else {
                            let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                            onError(error)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    public func deletePass(passType: String, serialNumber: String, clientPassData: [String: Any], onSuccess: @escaping () -> Void, onError: @escaping (_ error: PassNinjaError?) -> Void) {
        let isValidRequest = validatePass(passType: passType, endPointType: .Delete)
        var error: PassNinjaError?
        if let message = checkMissingAccountIdanApiKey() {
            error = try! PassNinjaError(message: message, statusCode: 500)
        }else if !isValidRequest{
            error = try! PassNinjaError(message: "Please enter a valid pass type and serial number", statusCode: 500)
        }else {
            provider.request(.deletePass(passType: passType, serialNumber: serialNumber)) { result in
                switch result{
                case .success(let response):
                    do {
                        print(try response.mapJSON())
                        if response.statusCode == 200 {
                            onSuccess()
                        } else {
                            let Json = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                            onError(Json)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    func checkMissingAccountIdanApiKey() -> String? {
        if passAccountId == "" || passApiKey == "" {
            return "Missing API Key. Make sure 'Passninja.init()' is called with a key from your Dashboard."
        }else {
            return nil
        }
    }
}

extension PassClient {
    func validatePass(passType: String, serialNumber: String? = nil, endPointType: EndpointType) -> Bool {
        var result = false
        switch endPointType {
        case .Create:
            result = (passType != "") ? true : false
        case .Get:
            result = (passType != "" && serialNumber != "") ? true : false
        case .Put:
            result = (passType != "" && serialNumber != "") ? true : false
        case . Delete:
            result = (passType != "" && serialNumber != "") ? true : false
        }
        return result
    }
}

public enum EndpointType {
    case Create
    case Get
    case Put
    case Delete
}
