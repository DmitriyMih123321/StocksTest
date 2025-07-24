//
//  DB.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 22.07.2025.
//

import Foundation
import CoreData
import UIKit
class DB {
    static func setFavStock(_ stock: ModelStocks, completionHandler: (() -> Void)? = nil) {
        
        let entity = NSEntityDescription.entity(forEntityName: "FavStocks", in: managedContext)!
        let record = NSManagedObject(entity: entity, insertInto: managedContext)
        
        record.setValue(stock.symbol ?? "", forKey: "symbol")
        record.setValue(stock.name ?? "", forKey: "name")
        record.setValue(stock.price ?? "", forKey: "price")
        record.setValue(stock.change ?? "", forKey: "change")
        record.setValue(stock.changePercent ?? "", forKey: "changePercent")
        record.setValue(stock.logo ?? "", forKey: "logo")
        record.setValue(stock.isFav, forKey: "isFav")
      
        do {
            try managedContext.save()
            print("--> Fav stock Added!", stock.name ?? "")
            
            if let callback = completionHandler {
                callback()
            }
        }
        catch let error as NSError {
            print("--> Could not SET because:", error.localizedDescription, error.userInfo)
            
            if let callback = completionHandler {
                callback()
            }
        }
    }
    
    static func getFavStocks() -> [ModelStocks] {
        
        var stocksArr = [ModelStocks]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"FavStocks")
        
        var items: [NSManagedObject] = [NSManagedObject]()
        
        managedContext.performAndWait {
            do {
                items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                
                items.forEach { item in
                    
                  
                    let stock = ModelStocks(symbol: item.value(forKey: "symbol") as? String ?? "", name: item.value(forKey: "name") as? String ?? "", price: item.value(forKey: "price") as? Double ?? 0.0, change: item.value(forKey: "change") as? Double ?? 0.0, changePercent: item.value(forKey: "changePercent") as? Double ?? 0.0, logo: item.value(forKey: "logo") as? String ?? "", isFav: item.value(forKey: "isFav") as? Bool ?? true)
                    stocksArr.append(stock)
                    
                }
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        return stocksArr
        
    }
    static func removeFavStock(_ stock: ModelStocks) {
        let predicate = NSPredicate(format: "symbol = %@", stock.symbol ?? "")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"FavStocks")
        fetchRequest.predicate = predicate
       
        var collections:[NSManagedObject] = [NSManagedObject]()
        managedContext.performAndWait {
            do {
                collections = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                collections.forEach { collect in
                    managedContext.delete(collect)
                    do {
                        try managedContext.save()
                        print("stock -> Record Removed!")
                    } catch let error as NSError{
                        print("stock -> Could not remove. \(error),\(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                print("stock -> Could not remove. \(error), \(error.userInfo)")
            }
        }
    }
}
extension NSManagedObject {
    func addObject(value: NSManagedObject, forKey key: String) {
        let items = self.mutableSetValue(forKey: key)
        items.add(value)
    }
    
    func removeObject(value: NSManagedObject, forKey key: String) {
        let items = self.mutableSetValue(forKey: key)
        items.remove(value)
    }
}
extension DB {
    static var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    static var managedContext: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
}
