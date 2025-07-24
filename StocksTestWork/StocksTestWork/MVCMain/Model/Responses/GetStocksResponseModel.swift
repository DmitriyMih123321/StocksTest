//
//  GetStocksResponseModel.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 22.07.2025.
//

import Foundation

struct GetStocksResponseModel {
    let stocks: [ModelStocks]
    typealias JSON = [String: Any]
    init(json: Any) throws {
        guard let array = json as? [JSON] else { throw NetworkError.someError}
        var stocks =  [ModelStocks]()
        for dictionary in array {
            guard let stock = ModelStocks(dict: dictionary) else { continue }
            stocks.append(stock)
        }
        self.stocks = stocks
    }
}

enum NetworkError: Error {
    case someError
}
