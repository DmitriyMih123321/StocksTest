//
//  NetworkService.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 22.07.2025.
//

import Foundation

class NetworkService {
    private init() {}
    
    static let shared = NetworkService()
    
    public func getDataJson(url: URL, completion: @escaping (Any)->()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    public func getData(url: URL, completion: @escaping (Any)->()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("getData error - \(String(describing: error))")
                return
            }
            completion(data)
        }.resume()
    }
    
}
