import Foundation

///A type erasure to store all kinds of SearchableKeyPath , TitledKey types in an array
///as long as they have the same Model type
public struct AnySearchableKey<Root : Sendable> : Sendable{
 
    private let stringProducer :  @Sendable (Root) -> [String]
    private let searchProducer : @Sendable ([Root], String, SearchStrategy) async -> [Root]?
    public let partialKey : PartialKeyPath<Root>
    
    public init<T : SearchableKeyProtocol>(_ item : T) where T.Item == Root  {
        self.stringProducer = { model in
            return item.stringify(model)
        }
        partialKey = item.key as PartialKeyPath<Root>
        searchProducer = { models , query , strategy in
            let key = SearchableKeyPath(key: item.key , stringifier: item.stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    
    
    
    public func stringify(_ model : Root ) -> [String] {
        
        stringProducer(model)
    }
    
    public func search(in models : [Root] , for query : String , strategy : SearchStrategy = .contains) async -> [Root]? {
        
        await searchProducer(models, query, strategy)
    }
    
}
public extension AnySearchableKey {
    
    init<Stringer : Stringifier> (_ key : KeyPath<Root, String> , stringer : Stringer = .default ) where Stringer.Model == String {
        
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    
    init<Stringer : Stringifier> (_ key : KeyPath<Root, Int> , stringer : Stringer = .default ) where Stringer.Model == Int {
        
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    init<Stringer : Stringifier> (_ key : KeyPath<Root, Double> , stringer : Stringer = .default ) where Stringer.Model == Double {
        
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    init<Stringer : Stringifier> (_ key : KeyPath<Root, Date> , stringer : Stringer = .default ) where Stringer.Model == Date {
        
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    init<Stringer : Stringifier> (_ key : KeyPath<Root, Bool> , stringer : Stringer = .default ) where Stringer.Model == Bool {
        
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    init<Stringer : Stringifier , T> (_ key : KeyPath<Root, T> , stringer : Stringer  ) where Stringer.Model == T {
        
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
}
