import Foundation

///A type erasure to store all kinds of SearchableKeyPath , TitledKey types in an array
///as long as they have the same Model type
public struct AnySearchableKey<Root : Sendable> : Sendable, Searchable , Identifiable,Equatable{
 
    public let id : UUID = UUID()
    public static func  == (lhs: AnySearchableKey<Root>, rhs: AnySearchableKey<Root>) -> Bool {
        return lhs.id == rhs.id
    }
    
    private let stringProducer :  @Sendable (Root) -> [String]
    private let searchProducer : @Sendable ([Root], String, SearchStrategy) async -> [Root]?
    public let partialKey : PartialKeyPath<Root>
    
    public init<T : SearchableKeyProtocol>(_ item : T) where T.Item == Root  {
        self.stringProducer = { model in
            return item.stringify(model)
        }
        partialKey = item.key as PartialKeyPath<Root>
        searchProducer = { models , query , strategy in
            //let key = SearchableKeyPath(item.key , stringifier: item.stringer)
            
            return await item.search(in: models, for: query,strategy: strategy)
            
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
    init<Key:CustomStringConvertible> (_ key : KeyPath<Root, Key>){
        let stringer = StringConvertableStringifier<Key>()
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    init<Key, Stringer : Stringifier> (_ key : KeyPath<Root, Key> , stringer : Stringer )
    where Stringer.Model == Key{
        
        self.stringProducer = { model in
            return stringer.stringify( model[keyPath: key])
        }
        self.partialKey = key
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
    }
    init(_ key : AnyKey<Root>) {
        self.partialKey = key.partialKey
        self.stringProducer = { model in
            return key.stringify(model)
        }
        self.searchProducer = {model , query , strategy in
                await key.search(in: model, for: query,strategy: strategy)
        }
    }
}
extension AnySearchableKey : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
