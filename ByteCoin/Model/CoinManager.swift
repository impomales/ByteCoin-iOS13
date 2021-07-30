//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager,_ coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    let secret: Secrets
    let baseURL: String
    let apiKey: String
    let currencyArray: [String]
    
    var delegate: CoinManagerDelegate?
    
    init() {
        self.secret = Secrets()
        self.baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
        self.apiKey = secret.apiKey
        self.currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    }
    
    func getCoinPrice(for currency: String) {
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
                    if let coinModel = self.parseJSON(safeData) {
                        delegate?.didUpdatePrice(self, coinModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return CoinModel(rate: decodedData.rate, currency: decodedData.asset_id_quote)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
