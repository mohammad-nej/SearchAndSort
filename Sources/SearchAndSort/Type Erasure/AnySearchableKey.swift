
///A type erasure to store all kinds of SearchableKeyPath , TitledKey types in an array
///as long as they have the same Model type
public struct AnySearchableKey<Root : Sendable> : Sendable{
 
    private let stringProducer :  @Sendable (Root) -> [String]
    
    let partialKey : PartialKeyPath<Root> 
    
    init<T : SearchableKeyProtocol>(_ item : T) where T.Item == Root  {
        self.stringProducer = { model in
            return item.stringify(model)
        }
        partialKey = item.key as PartialKeyPath<Root> 
    }
    
    func stringify(_ model : Root ) -> [String] {
        
        stringProducer(model)
    }
    
    
}
