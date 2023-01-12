//
//  CoinService.swift
//  ByteCoin
//
//  Created by Jeevan Chandra Joshi on 12/01/23.
//

import Foundation

protocol CoinServiceDelegate {
    func didUpdatePrice(_ coin: CoinModel)
    func didFailWithError(_ error: Error)
}

struct CoinService {
    var delegate: CoinServiceDelegate?

    let apiKey = ""
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"

    let currencies = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]

    var currency = "INR"

    mutating func fetchCoinPrice(_ currency: String) {
        self.currency = currency
        let endpoint = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(endpoint)
    }

    func performRequest(_ endpoint: String) {
        if let url = URL(string: endpoint) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                if let coinData = data {
                    if let coin = parseData(coinData) {
                        delegate?.didUpdatePrice(coin)
                    }
                }
            }
            task.resume()
        }
    }

    func parseData(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(CoinData.self, from: coinData)
            let coin = CoinModel(price: data.rate, currency: currency)
            return coin
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
