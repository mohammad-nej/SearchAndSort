
///A type erasure to store all kinds of SearchableKeyPath , TitledKey types in an array
///as long as they have the same Model type
public struct AnySearchableKey<Root : Sendable> : Sendable{
 
    private let stringProducer :  @Sendable (Root) -> [String]
    
    public let partialKey : PartialKeyPath<Root> 
    
    public init<T : SearchableKeyProtocol>(_ item : T) where T.Item == Root  {
        self.stringProducer = { model in
            return item.stringify(model)
        }
        partialKey = item.key as PartialKeyPath<Root> 
    }
    
    public func stringify(_ model : Root ) -> [String] {
        
        stringProducer(model)
    }
    
    
}
