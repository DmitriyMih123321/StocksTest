//
//  GetCheckedFavStocks.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 23.07.2025.
//

import Foundation

class GetCheckedFavStocks {
    static func checkFavourite(stocksAll: [ModelStocks]) -> (changed: [ModelStocks],favs: [ModelStocks]){
        var stocksAll = stocksAll
        let stocksFavArray = DB.getFavStocks()
        for index in stocksAll.indices {
            let stock = stocksAll[index]
            stocksAll[index].isFav = stocksFavArray.contains { $0.symbol == stock.symbol }
        }
        return (stocksAll, stocksFavArray)
    }
}
