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

open class PassClient {
    
    public static let shared = PassClient()
    fileprivate let provider = MoyaProvider<EndPoint>()
    
    public func getPassTemplate(passType: String, onSuccess: @escaping (_ response: PassTemplate) -> Void,
                        onError: @escaping (_ error: PassNinjaError?) -> Void) {
        provider.request(.getPassTemplate(passType: passType)) { result in
            switch result{
            case .success(let response):
                do {
                    if response.statusCode == 200 {
                        let pass = try JSONDecoder().decode(PassTemplate.self, from: response.data)
                        onSuccess(pass)
                    } else {
                        let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                        onError(error)
                    }
                } catch {
                    onError(commonError())
                }
            case.failure:
                onError(commonError())
            }
        }
        if let error = error {
            onError(error)
        }
    }

    public func createPass(pass: PassRequest,
                           onSuccess: @escaping (_ response: Pass) -> Void,
                           onError: @escaping (_ error: PassNinjaError?) -> Void) {
        let isValidRequest = validatePass(passType: pass.passType, endPointType: .Create)
        var error: PassNinjaError?
        if let message = checkMissingAccountIdanApiKey() {
            error = try! PassNinjaError(message: message, statusCode: 500)
        }else if !isValidRequest{
            error = try! PassNinjaError(message: "Please enter a valid pass type", statusCode: 500)
        }else{
            getPassTypeRequiredKeys(passType: pass.passType, onSuccess: { (requirePassKey) in
                let requirePassKeySet:Set<String> = Set(requirePassKey.keys ?? [])
                let passKeys = pass.pass?.map({ $0.key })
                let passKeySet:Set<String> = Set(passKeys ?? [])
                let intersection = requirePassKeySet.intersection(passKeySet)
                
                if intersection.count >= passKeys?.count ?? 0 || requirePassKeySet.count == 0 {
                    self.provider.request(.createPass(pass: pass)) { result in
                        switch result{
                        case .success(let response):
                            do {
                                if response.statusCode == 200 {
                                    let pass = try JSONDecoder().decode(Pass.self, from: response.data)
                                    onSuccess(pass)
                                } else {
                                    let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                                    onError(error)
                                }
                            } catch {
                                onError(commonError())
                            }
                        case.failure:
                            onError(commonError())
                        }
                    }
                }else {
                    onError(try! PassNinjaError(message: "Please enter valid pass keys", statusCode: 500))
                }
            }) { (error) in
                onError(error)
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    public func getPass(passType: String, serialNumber: String,
                        onSuccess: @escaping (_ response: Pass) -> Void,
                        onError: @escaping (_ error: PassNinjaError?) -> Void) {
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
                        if response.statusCode == 200 {
                            let pass = try JSONDecoder().decode(Pass.self, from: response.data)
                            onSuccess(pass)
                        } else {
                            let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                            onError(error)
                        }
                    } catch {
                        onError(commonError())
                    }
                case.failure:
                    onError(commonError())
                }
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    public func putPass(pass: PassRequest,
                        onSuccess: @escaping (_ response: Pass) -> Void,
                        onError: @escaping (_ error: PassNinjaError?) -> Void) {
        let isValidRequest = validatePass(passType: pass.passType, serialNumber: pass.serialNumber,endPointType: .Put)
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
                        if response.statusCode == 200 {
                            let pass = try JSONDecoder().decode(Pass.self, from: response.data)
                            onSuccess(pass)
                        } else {
                            let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                            onError(error)
                        }
                    } catch {
                        onError(commonError())
                    }
                case.failure:
                    onError(commonError())
                }
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    public func deletePass(passType: String,
                           serialNumber: String,
                           clientPassData: [String: Any],
                           onSuccess: @escaping () -> Void,
                           onError: @escaping (_ error: PassNinjaError?) -> Void) {
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
                        if response.statusCode == 200 {
                            onSuccess()
                        } else {
                            let Json = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                            onError(Json)
                        }
                    } catch {
                        onError(commonError())
                    }
                case.failure:
                    onError(commonError())
                }
            }
        }
        if let error = error {
            onError(error)
        }
    }
    
    public func getPassTypeRequiredKeys(passType: String,
                                        onSuccess: @escaping (_ response: RequiredPassKey) -> Void,
                                        onError: @escaping (_ error: PassNinjaError?) -> Void) {
        provider.request(.getPassTypeKeys(passType: passType)) { result in
            switch result{
            case .success(let response):
                do {
                    if response.statusCode == 200 {
                        let pass = try JSONDecoder().decode(RequiredPassKey.self, from: response.data)
                        onSuccess(pass)
                    } else {
                        let error = try JSONDecoder().decode(PassNinjaError.self, from: response.data)
                        onError(error)
                    }
                } catch {
                    onError(commonError())
                }
            case.failure:
                onError(commonError())
            }
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

fileprivate extension PassClient {
    func validatePass(passType: String,
                      serialNumber: String? = nil,
                      endPointType: EndpointType) -> Bool {
        var result = false
        switch endPointType {
        case .Create:
            result = (passType != "") ? true : false
        case .Get:
            if let serialNumber = serialNumber {
                result = (passType != "" && serialNumber != "") ? true : false
            }
        case .Put:
            if let serialNumber = serialNumber {
                result = (passType != "" && serialNumber != "") ? true : false
            }
        case .Delete:
            result = (passType != "" && serialNumber != "") ? true : false
        case .GetPassType:
            result = (passType != "") ? true : false
        }
        return result
    }
}

public enum EndpointType {
    case Create
    case Get
    case Put
    case Delete
    case GetPassType
}

func commonError() -> PassNinjaError {
    return try! PassNinjaError(message: "Invalid JSON Error", statusCode: 403)
}
