//
//  StocksNetworkService.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 22.07.2025.
//

import Foundation

class StocksNetworkService {
    private init() {}
    
    static func getStocks(completion: @escaping (GetStocksResponseModel) -> ()){
        guard let url = URL(string: "https://mustdev.ru/api/stocks.json") else { return }
        
        NetworkService.shared.getDataJson(url: url, completion: { json in
            do {
                let response = try GetStocksResponseModel(json: json)
                completion(response)
            } catch {
                print(error)
            }
        })
    }
}
