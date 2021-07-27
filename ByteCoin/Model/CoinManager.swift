//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    let secret: Secrets
    let baseURL: String
    let apiKey: String
    let currencyArray: [String]
    
    init() {
        self.secret = Secrets()
        self.baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
        self.apiKey = secret.apiKey
        self.currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    }
    
}
