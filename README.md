# Search And Sort on the Background

This swift package lets you **Search** and **Sort** any `Sendable` array on the background thread based on your provided `KeyPath`(s) in a **Type Safe** manner. 


## Installation: 
You should import the package using Swift Package Manager in your project. 
### Xcode Projects:
To import the package to your existing project simply open _File -> Add Package Dependencies_ and   copy paste [URL](https://github.com/mohammad-nej/SearchAndSort) to SPM.
### Swift Package:
To import to a swift package add the following url to your package dependencies: 

  `  .package(url: "https://github.com/mohammad-nej/SearchAndSort", .upToNextMajor(from: "1.0.1")),`
  
you should also add it as a product to your targets : 
`  .product(name: "SearchAndSort", package: "SearchAndSort"),`

 

This package provides different types for Searching , Sorting based on `KeyPaths` to `Sendable` types.

## Sorting:

Assuming we have a `Student` type : 

```swift
struct Student : Sendable { 
  let name : String
  let age : Int
  let grade : Double
  let birthDate : Date
}
```

if we want to sort an of `Student`s based on `name` : 
```swift
 let students : [Studnet] = []
 // we fill the students array
 let nameKey = SortableKeyPath(\Student.name)
 let sortedArray = nameKey.sort(students, order: .ascending)
```
### Type Erasing :
in order to create a `SortableKeyPath` you type should be `Sendable` and the key should conform to `Comparable` protocol otherwise you will get compile-time error.

if you want to be able to sort based on multiple `Key`s you can use `AnySortable` type erasure which will erase you `Key` type:
```swift
let nameKey = SortableKeyPath(\Student.name)
let ageKey = SortableKeyPath(\Student.age)
let keys : [AnySortableKey] = [.init(nameKey,order: .ascending), .init(ageKey,order: .descending)]
```
**Note:** this will only erase  `Key`s type, thus you can't store `SortableKeyPath`s of different models in the same array.

## Searching
 in order to be able to search based on a a `KeyPath` you need to provide a type conforming to  `Stringifier` protocol. This protocol only has 1 method : 
 ```swift
public protocol Stringifier : Sendable  {
    
    associatedtype Model 
    
    func stringify(_ model : Model) -> [String]
}
```
#### example:

assuming that we want to impelent this protocol for `Int` type : 
```swift
 struct IntStringifier : Stringifier, Sendable {
     func stringify(_ model: Int) -> [String] {
        var results : [String] = []
        results.append(model.formatted())
        results.append(model.description)
        return results
    }
}
```
this way when `BackgroundSearcher` is itterating over your models, it will converted every `Int` to an **array of strings** and match it with your search query.
for example with this `IntStringifier` your use will get a match for 2000 ethier if he enters "2000" or "2,000" as query.

**Goo news:** this package already impleneted `Stringifier` for `Date`,`Int`,`String`,`Double` and they are passed as default values thus you don't need to worry about that.

### Creating SearchableKey:

with that being said lets create `SearchableKey`:
```swift
 let nameKey = SearchableKeyPath(key:\Student.name)
 let ageKey = SearchableKeyPath(key:\Student.age)
 let dateKey = SearchableKeyPath(key: \Student.birthDate, stringifier: MyOwnStringifier())
```
we can now search on any array of type `Student` using these keys:
```swift
 let searchResult = await nameKey.search(in:studnets , for: "John")
 let searchResult = await ageKey.search(in:studnets , for: "John", strategy: .exact)
```
**Note:** search function will return `nil` if it's canceled before finishing and it will return an empty array if doesn't find anything.
**Notes:** you can choose between different matching strategies, the default value is `.contains`.

### Type Erasing :
just like Sorting you can also use `AnySearchableKey` to type erase your keys and store them in an array:
```swift
let keys : [AnySearchableKey] = [.init(nameKey), .init(ageKey)]
```

## BackgroundSearcher
  this is an actor that actually does the search for you. it will create `Task.detached`(s) internally depending on the size of your array.

  you can pass your models and keys to this type and let it do the search for you.
  ```swift
  let searcher = BackgroundSearcher(models: studnets,keys: [.init(nameKey),.init(ageKey)])
  await searcher.search("John" ,withKey: [.init(nameKey)] , strategy: .prefix)
  ```
  **Notes:**
  1. if you dont provide a value for `withKey:` parameter it will itterate over all the `Key`s that you provided during initialzation.
  2. when you are calling `search` directly from a `SearchableKeyPath` an instance of `BackgroundSearcher` is created internally.
  3. `BackgroundSearcher` will create multiple `Task`s if you array size exceeds `1500`, you can change this number by setting `minimumElementsToMultiThread`.

## Sorter
just like `BackgroundSearcher`, `Sorter` will let you store all your models and keys in one place:
```swift
let nameSort = SortableKeyPath(\Student.name)
let ageSort = SortableKeyPath(\Student.age)
let sorter = Sorter(models: students, keys: [.init(nameSort), order: .init(ageSort))
```
**Note:** unlike `BackgroundSearcher`, `Sorter` will always create 1 `Task` regardless of the size of your array.

## TitledKey
this type can be used to provide a title for your keys ( e.g. you want to show it in the UI).
```swift
let titledNameKey = TitledKey(title: "Name", key: \Student.name, stringer: .default)
```
this type can be replaced by `SearchableKeyPath` and you can also use it in place of a `SortableKeyPath` if the `Key` that you are providing conforms to `Comparable` protocol.

so it can be used as an input to `BackgroundSearcher` , `AnySearchableKey` and `Sorter` , `AnySortableKey` ( if the key is `Comparable`). the only downside to use this type is that if you only want to do sort, you always have to provide `Stringifier` for your `Key` type.



