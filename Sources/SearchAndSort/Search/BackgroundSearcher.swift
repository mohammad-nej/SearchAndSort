//
//  BackgroundSearcher.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

//
//  Background.swift
//  MelikaArt
//
//  Created by MohammavDev on 11/4/24.
//


import SwiftData
import Foundation



public final actor BackgroundSearcher<T : Sendable>  {
    

    public private(set) var _allModels : [T]
    
    public let useWildCards : Bool
    var tasks : [Task<[T]?, Never>] = []
    //private var isCanceled = false
    
    public let keys : [AnySearchableKey<T>]

    init(models : [T]  , keys : [AnySearchableKey<T>] = [] , useWildCards : Bool = true){
        
        _allModels = models
        self.keys = keys
        self.useWildCards = useWildCards
    }
    public func seach(_ query : String , withKey key : AnySearchableKey<T>? = nil) async throws -> [T]? {
        
        cancelAllTasks()
        guard query != ""   else { return nil}
        
        if useWildCards{
            if query == "همه" || query == "*" {
                return _allModels
            }
        }
        var resutls : [T] = []
        let allModels = _allModels
        let searchingKeys = key == nil ? self.keys : [key!]
        let checker = self.checkIf
        let task  = Task.detached(priority: .userInitiated) { //[weak self] in
            //guard let self else { return Optional<[T]>.none }
            MODELS: for model in allModels {
                if  Task.isCancelled  {
                    return Optional<[T]>.none
                }
                for key in searchingKeys {
                   
                    for value in key.stringify(model) {
                        if checker(value, query) {
                            resutls.append(model)
                            continue MODELS
                        }
                    }
                }
            }
            return resutls

        }
        tasks.append(task)
        return await task.value
    }
    func cancelAllTasks(){
        tasks.forEach{
            $0.cancel()
        }
        tasks.removeAll()
    }
    
    func checkIf(_ object : String , has query : String) -> Bool{
        
        
        let startsWtih = query.hasPrefix("“") || query.hasPrefix("\"")
        let endsWtih = query.hasSuffix("”") || query.hasSuffix("\"")
    
        if startsWtih && endsWtih{
            
            //These 3 might look the same but they have different codes,
            //thus must be removed regardless
            var removed = query.replacingOccurrences(of: "\"", with: "")
            removed = removed.replacingOccurrences(of: "”", with: "")
            removed = removed.replacingOccurrences(of: "“", with: "")
            
            return object == removed || object == removed.lowercased()
        }else{
            return object.contains(query) || object.contains(query.lowercased())
        }
    }
//    func search(_ query : String, withKey key : PartialKeyPath<T>? = nil) async -> [T]?{
//        
//        cancelAllTasks()
//       // await autoFetch()
//        guard query != ""   else { return nil}
//        
//        if useWildCards{
//            if query == "همه" || query == "*" {
//                return _allModels
//            }
//        }
//        let allModels = _allModels
//        let keys = key == nil ?  self.keys : [key!]
//        let task = Task.detached(priority: .userInitiated){ [weak self]  in
//            guard let self else { return Optional<[T]>.none }
//            var filtered : [T] = []
//            let lowerCased = query.lowercased()
//            
//            
//            MODELS: for  model in allModels {
//                
//                if Task.isCancelled { return Optional<[T]>.none }
//                for key in   keys{
//                    if let key = key as? KeyPath<T,Int> {
//                        let modelKey = model[keyPath: key]
//                        let result1 =  self.checkIf( modelKey.description, has: lowerCased)
//                        let result2 =  self.checkIf( modelKey.formatted(), has: lowerCased)
//                        
//                        if result1 || result2  {
//                            filtered.append(model)
//                            continue MODELS
//                        }
//                        
//                    }
//                    
//                    if let key = key as? KeyPath<T,Double>  {
//                        let modelKey = model[keyPath: key]
//                        let condition1 =  checkIf(modelKey.description, has: lowerCased)
//                        let condition2 =  checkIf(modelKey.formatted(), has: lowerCased)
//                        
//                        
//                        if  condition1 || condition2{
//                            filtered.append(model)
//                            continue MODELS
//                        }
//                        
//                    }
//                    
//                    if let key = key as? KeyPath<T,String>  {
//                        let modelKey = model[keyPath: key]
//                        if  checkIf(modelKey.lowercased(), has: lowerCased) {
//                            filtered.append(model)
//                            continue MODELS
//                        }
//                        
//                    }
//                    
//                    if let key = key as? KeyPath<T,Date>  {
//                        let modelKey = model[keyPath: key]
//                        let formatted = dateFormatter.string(from:  modelKey)
//                        let secondFormat = secondDateFormatter.string(from:  modelKey)
//                        
//                        let condition1 =  checkIf(formatted,has:lowerCased)
//                        let condition2 =  checkIf(secondFormat, has: lowerCased)
//                        if condition1 || condition2  {
//                            filtered.append(model)
//                            continue MODELS
//                        }
//                        
//                    }
//                    let value = model[keyPath: key]
//                    if let extracted = value as? (any MyIterableEnum){
//                        
//                        //let modelKey = model[keyPath: key]
//                        let formatted = extracted.description
//                        if checkIf(formatted, has: lowerCased){
//                            filtered.append(model)
//                            continue MODELS
//                        }
//                        
//                    }
//                    //debugginLogger.error("keypath \(key.hashValue) is not supported")
//                }
//            }
//            
//            return filtered
//        }
//        tasks.append(task)
//        return await task.value
//    }
    
    
    
}

