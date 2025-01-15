//
//  BackgroundSearcher.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//



import SwiftData
import Foundation
import OSLog

 public enum SearchStrategy: CaseIterable , Sendable{
    case prefix
    case contains
    case exact
}

public final actor BackgroundSearcher<T : Sendable>  {
    
  
    
    
    private let logger = Logger(subsystem: "Background Searcher", category: "SearchAndSort")
    
    public private(set) var _allModels : [T]
    
    
    ///This indicate that if you can use * in your search term to
    ///return all models
    public let useWildCards : Bool
    
    private var tasks : [Task<[T]?, Never>] = []
    
    
    ///This will change max number of threads that can run simoultaniusly,
    ///it's advised to not increase any more than 5-6.
    public var maxNumberOfThreads : Int = 5
    
    ///determines the search strategy used for search function
    public var searchStrategy : SearchStrategy = .contains
    
    ///If number  of elements in your array exceed these number, it will start to
    ///create TaskGroup instead.
    public var minimumElementsToMultiThread : Int = 1500
    
    ///If TaskGroups are created this is the number of elements in each child task,
    ///otherwise have no effect
    public var maxNumberOfElementsInEachChunk : Int = 1000
    
    ///Keys that the searcher can search based of them.
    public let keys : [AnySearchableTitledKey<T>]
    
    
    public init (models : [T] , keys : [AnySearchableTitledKey<T>],strategy: SearchStrategy = .contains ,useWildCards : Bool = true){
        _allModels = models
        self.keys = keys
        self.useWildCards = useWildCards
        self.searchStrategy = strategy
    }

    
    public init(models : [T]  , keys : [AnySearchableKey<T>]  ,strategy: SearchStrategy = .contains ,useWildCards : Bool = true){
       
       _allModels = models
       self.keys = keys.map{ AnySearchableTitledKey($0,title:"Not Provided")}
       self.useWildCards = useWildCards
       self.searchStrategy = strategy
   }
    public init(models : [T]  , keys : [AnyKey<T>]  ,strategy: SearchStrategy = .contains ,useWildCards : Bool = true){
       
       _allModels = models
       self.keys = keys.map{ AnySearchableTitledKey($0,title:"Not Provided")}
       self.useWildCards = useWildCards
       self.searchStrategy = strategy
   }

    
    
    private func multiThreadSearch(_ query : String , withKeys key : [AnySearchableTitledKey<T>]? = nil) async  -> [T]? {
        
        let maxNumberOfElementsInEachChunk = self.maxNumberOfElementsInEachChunk
        let maxNumberOfThreads = self.maxNumberOfThreads
        
        let _allModels = self._allModels
        return await withTaskGroup(of: [T]?.self, returning: [T]?.self) { group in
            
            
            let chunksCount =  Int((Double(_allModels.count) / Double(maxNumberOfElementsInEachChunk)).rounded(.up))
            logger.debug("models chunked into \(chunksCount) sub-arrays")
            let numberOfTask = min(chunksCount , maxNumberOfThreads)
            logger.debug("Number of concurrent tasks : \(numberOfTask) for \(query)")
            var index = 0
            var finalResult : [T]? = nil
            
            
            for index in 0..<numberOfTask {
                group.addTask{
                    if Task.isCancelled {
                        return nil
                    }
                    let firstIndex =  index * maxNumberOfElementsInEachChunk
                    let lastIndex =  min((index + 1) * maxNumberOfElementsInEachChunk , _allModels.count)
                    
                    self.logger.debug("Searching from \(firstIndex) to \(lastIndex) for \(query)")
                    
                    let partialResult =
                    await self.singleThreadSearch(query ,
                                                  models: _allModels[firstIndex..<lastIndex],
                                                  withKeys: key)
                    
                    
                    return partialResult
                    
                }
            }
            index = numberOfTask
            for await result in group {
                
                if finalResult == nil { finalResult = [] }
                
                //if we get a nil result , means that the task is already been canceled
                guard let result else { return nil}
                finalResult!.append(contentsOf: result)
                
                index += 1
                
                let currentIndex = index
                if currentIndex < chunksCount {
                    group.addTask {
                        let firstIndex =  currentIndex * maxNumberOfElementsInEachChunk
                        let lastIndex =  min((currentIndex + 1) * maxNumberOfElementsInEachChunk , _allModels.count)
                        if Task.isCancelled{
                            self.logger.debug("Task for  \(query) from \(firstIndex) to \(lastIndex) cancelled")
                            return nil}
                        
                     
                        self.logger.debug("Searching from \(firstIndex) to \(lastIndex) for \(query)...")
                        let partialResult =
                        await self.singleThreadSearch(query
                                                      ,models: _allModels[firstIndex..<lastIndex]
                                                      , withKeys: key)
                        
                        return partialResult
                    }
                    
                }
            }
            
            return finalResult
        }
        
        
    }
    private func singleThreadSearch(_ query : String , models: ArraySlice<T> ,withKeys key : [AnySearchableTitledKey<T>]? = nil) async  -> [T]? {
        var resutls : [T] = []
        let allModels = models
        let searchingKeys = key == nil ? self.keys : key!
        let checker = self.checkIf
        let task  = Task.detached(priority: .userInitiated) {
            MODELS: for model in allModels {
                if  Task.isCancelled  {
                    self.logger.debug("Task for \(query) cancelled")
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
        
        
        let result = await task.value
        logger.debug("Task is finished...")
        tasks.removeAll { element in
            element == task
        }

        
        return  result
        
    }
    
  
    ///You can pass a key to limit Searcher to that specefic keys, otherwise it will itterate over all the keys.
    ///This function use Task.detached internally so it will always run off the main thread
    ///search function will return empty array if doesn't find anything. nil is returned if a task is canceled before completion.
    public func search(_ query : String , withKey key : [AnySearchableTitledKey<T>]? = nil, strategy : SearchStrategy? = nil) async -> [T]? {
        logger.debug("Start searching for \(query)...")
        let backup = searchStrategy
        defer{
            self.searchStrategy = backup
        }
        let currentStrategy = strategy == nil ? backup : strategy!
        
        
        
        self.searchStrategy = currentStrategy
      
        cancelAllTasks()
        guard query != ""   else { return nil}
        
        if useWildCards{
            
            if query == "همه" || query == "*" {
                logger.debug("Wildcard search found, returning all models...")
                return _allModels
            }
        }
        
        
            let allModels =  _allModels
            let minimumElementsToMultiThread = self.minimumElementsToMultiThread
            let logger = logger
        return await Task.detached(priority: .userInitiated){ [self] in
            if  allModels.count < minimumElementsToMultiThread{
                
                logger.debug("Searching with single thread...")
                return  await self.singleThreadSearch(query , models: _allModels , withKeys: key)
            }else {
                logger.debug("Multi thread search...")
                return await self.multiThreadSearch(query, withKeys: key)
            }
        }.value
    }
    private func singleThreadSearch(_ query : String , models: [T] ,withKeys key : [AnySearchableTitledKey<T>]? = nil) async -> [T]? {
        
        var resutls : [T] = []
        let allModels = _allModels
        let searchingKeys = key == nil ? self.keys : key!
        let checker = self.checkIf
        let task  = Task.detached(priority: .userInitiated) {
            
            MODELS: for model in allModels {
                if  Task.isCancelled  {
                    self.logger.debug("Task for \(query) cancelled")
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
        let result = await task.value
        //logger.log("Task is finished...")
        tasks.removeAll { element in
            element == task
        }
        return  result
    }
    
    
    
    
}

public extension BackgroundSearcher {
    
    func setMaxNumberOfElementsInEachChunk(_ maxNumberOfElementsInEachChunk : Int){
        self.maxNumberOfElementsInEachChunk = maxNumberOfElementsInEachChunk
    }
    func setSearchStrategy(_ searchStrategy : SearchStrategy){
        self.searchStrategy = searchStrategy
    }
}
public extension BackgroundSearcher {
}
public extension BackgroundSearcher {
    func loadModels(_ models : [T]) {
        _allModels = models
    }
    private func checkIf(_ object : String , has query : String) -> Bool{
        
        switch searchStrategy {
            case .contains:
                if useWildCards{
                    let startsWtih = query.hasPrefix("“") || query.hasPrefix("\"")
                    let endsWtih = query.hasSuffix("”") || query.hasSuffix("\"")
                    
                    if startsWtih && endsWtih{
                        
                        //These 3 might look the same but they have different codes,
                        //thus must be removed regardless
                        var removed = query.replacingOccurrences(of: "\"", with: "")
                        removed = removed.replacingOccurrences(of: "”", with: "")
                        removed = removed.replacingOccurrences(of: "“", with: "")
                        
                        return object == removed || object == removed.lowercased()
                    }else {
                        return object.contains(query) || object.contains(query.lowercased())
                    }
                }else{
                    return object.contains(query) || object.contains(query.lowercased())
                }
            case .prefix:
                return object.starts(with: query) || object.starts(with: query.lowercased())
            case .exact:
                return object == query || object == query.lowercased()
                
        }
    }
    ///This function will be called when starting a new search , but you can also call it at any time
    ///to cancel all active task.
    func cancelAllTasks(){
        guard !tasks.isEmpty else {
            logger.debug("No tasks to cancel.")
            return }
        let count = tasks.count
        logger.debug("Cancelling \(count) tasks.")
        tasks.forEach{
            $0.cancel()
        }
        tasks.removeAll()
    }
}
