//
//  ModelStocks.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 21.07.2025.
//

import Foundation

struct ModelStocks {
    var symbol: String?
    var name: String?
    var price: Double?
    var change: Double?
    var changePercent: Double?
    var logo: String?
   
    var isFav = false
    init() {
    }
    init(symbol: String?, name: String?, price: Double?, change: Double?, changePercent: Double?, logo: String? = nil, isFav: Bool) {
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change = change
        self.changePercent = changePercent
        self.logo = logo
        self.isFav = isFav
    }
    
    init?(dict: [String: Any]){
        guard let symbol = dict["symbol"] as? String,
              let name = dict["name"] as? String,
              let price = dict["price"] as? Double,
              let change = dict["change"] as? Double,
              let changePercent = dict["changePercent"] as? Double,
              let logo = dict["logo"] as? String else {
                  return
              }
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change = change
        self.changePercent = changePercent
        self.logo = logo
              
    }

}

