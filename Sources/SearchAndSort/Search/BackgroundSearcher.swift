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

import OSLog

public final actor BackgroundSearcher<T : Sendable>  {
    
    let logger = Logger(subsystem: "Background Searcher", category: "SearchAndSort")

    public private(set) var _allModels : [T]
    
    
    ///This indicate that if you can use * in your search term to
    ///return all models
    public let useWildCards : Bool
    private var tasks : [Task<[T]?, Never>] = []
    //private var isCanceled = false
    
    ///This will change max number of threads that can run simoultaniusly,
    ///it's advised to not inrease any more than 5-6.
    public var maxNumberOfThreads : Int = 5
    
    ///If number  of elements in your array exceed these number, it will start to
    ///create TaskGroup instead.
    public var minimumElementsToMultiThread : Int = 1500
    ///If TaskGroups are created this is the number of elements in each child task,
    ///otherwise have no effect
    public var maxNumberOfElementsInEachChunk : Int = 1000
    
    ///Keys that the searcher can search based of them.
    public let keys : [AnySearchableKey<T>]

    init(models : [T]  , keys : [AnySearchableKey<T>] = [] , useWildCards : Bool = true){
        
        _allModels = models
        self.keys = keys
        self.useWildCards = useWildCards
    }
    public func setMaxNumberOfElementsInEachChunk(_ maxNumberOfElementsInEachChunk : Int){
        self.maxNumberOfElementsInEachChunk = maxNumberOfElementsInEachChunk
    }
    private func multiThreadSearch(_ query : String , withKey key : AnySearchableKey<T>? = nil) async  -> [T]? {
       
        let maxNumberOfElementsInEachChunk = self.maxNumberOfElementsInEachChunk
        let maxNumberOfThreads = self.maxNumberOfThreads
        
        let _allModels = self._allModels
        return await withTaskGroup(of: [T].self, returning: [T]?.self) { group in
            
            
            let chunksCount =  Int((Double(_allModels.count) / Double(maxNumberOfElementsInEachChunk)).rounded(.up))
            logger.debug("models chunked into \(chunksCount) sub-arrays")
            let numberOfTask = min(chunksCount , maxNumberOfThreads)
            logger.debug("Number of concurrent tasks : \(numberOfTask)")
            var index = 0
            var finalResult : [T] = []
            
            
            for index in 0..<numberOfTask {
                group.addTask{
                    //self.logger.debug("task number \(index) started...")
                    let firstIndex =  index * maxNumberOfElementsInEachChunk
                    let lastIndex =  min((index + 1) * maxNumberOfElementsInEachChunk , _allModels.count - 1)
                    self.logger.debug("Searching from \(firstIndex) to \(lastIndex)")
                    let partialResult =
                    await self.singleThreadSearch(query ,
                                                  models: _allModels[firstIndex...lastIndex]                                       , withKey: key)
                    
                    guard let partialResult else { return [] }
                    return partialResult
                    
                }
            }
            index = numberOfTask
            for await result in group {
                
                finalResult.append(contentsOf: result)
                index += 1
                
                let currentIndex = index
                if currentIndex < chunksCount {
                    group.addTask {
                        //self.logger.debug("task number \(currentIndex) started...")
                        let firstIndex =  currentIndex * maxNumberOfElementsInEachChunk
                        let lastIndex =  min((currentIndex + 1) * maxNumberOfElementsInEachChunk , _allModels.count - 1)
                        self.logger.debug("Searching from \(firstIndex) to \(lastIndex)")
                        let partialResult =
                        await self.singleThreadSearch(query , models: _allModels[firstIndex...lastIndex]                                       , withKey: key)
                        //currentChunk = chunks.index(after: currentChunk)
                        guard let partialResult else { return [] }
                        return partialResult
                    }
                    
                }
            }
            logger.debug("Result : \(finalResult)")
            return finalResult
        }
        
        
    }
    private func singleThreadSearch(_ query : String , models: ArraySlice<T> ,withKey key : AnySearchableKey<T>? = nil) async  -> [T]? {
        var resutls : [T] = []
        let allModels = models
        let searchingKeys = key == nil ? self.keys : [key!]
        let checker = self.checkIf
        let task  = Task.detached(priority: .userInitiated) {
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
        
        return await task.value
        
    }
    ///You can pass a key to limit Searcher to that specefic key, otherwise it will itterate over all the keys.
    ///This function use Task.detached internally so it will always run off the main thread
    public func search(_ query : String , withKey key : AnySearchableKey<T>? = nil) async -> [T]? {
        if _allModels.count < minimumElementsToMultiThread{
            logger.debug("Searching with single thread...")
            return  await singleThreadSearch(query , models: _allModels , withKey: key)
        }else {
            logger.debug("Multi thread search...")
            return await multiThreadSearch(query, withKey: key)
        }
    }
    private func singleThreadSearch(_ query : String , models: [T] ,withKey key : AnySearchableKey<T>? = nil) async -> [T]? {
        logger.debug("Canceling previous tasks...")
        cancelAllTasks()
        guard query != ""   else { return nil}
        
        if useWildCards{
            
            if query == "همه" || query == "*" {
                logger.debug("Wildcard search found, returning all models...")
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
    private func cancelAllTasks(){
        tasks.forEach{
            $0.cancel()
        }
        tasks.removeAll()
    }
    
    private func checkIf(_ object : String , has query : String) -> Bool{
        
        
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

}

