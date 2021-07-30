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
    
    func getCoinPrice(for currency: String) {
        print(currency)
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if (error != nil) {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let bitcoinPrice = self.parseJSON(safeData)
                    print(bitcoinPrice!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
        } catch {
            return nil
        }
    }
}
