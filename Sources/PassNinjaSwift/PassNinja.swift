//
//  PassNinja.swift
//  PassNinja
//
//  Created by Sagar Radadiya on 29/10/20.
//  Copyright © 2020 Flomio. All rights reserved.
//

import Foundation

var passAccountId = ""
var passApiKey = ""

public class PassNinja {
    
    public static func initWith(accountId: String, apiKey: String) {
        passAccountId = accountId
        passApiKey = apiKey
    }
}
