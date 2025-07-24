//
//  StocksIconNetworkService.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 22.07.2025.
//

import Foundation

class StocksIconNetworkService {
    private init() {}
   
    static func getStockIcons(url: URL?, completion: @escaping (Data) -> ()){
        guard let url = url else { return }
        
        NetworkService.shared.getData(url: url, completion: { imgData in
            guard let data = imgData as? Data else {
                print("getStockIcons error")
                return
            }
            completion(data)
        })
    }
}
