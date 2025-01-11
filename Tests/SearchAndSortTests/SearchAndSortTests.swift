import Testing
import Foundation
@testable import SearchAndSort

struct Family : Sendable{
    let name  : String
}
struct Numbered : Sendable {
    let number : Int
}
struct FamilyStringifier : Stringifier {
    typealias Model = Family
    func stringify(_ value: Family) -> [String] {
        return [value.name]
    }
}
struct Student : Identifiable , Equatable {
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let name : String
    let age : Int
    let grade : Double
    let birthDate : Date
    
    let family : Family
}

struct Person {
    let name : String
}
struct Tests {
    let ali = Student(name: "Ali", age: 12, grade: 12.4, birthDate: Date(), family: .init(name: "something"))
    
    
    let key = TitledKey(title: "Grade", key: \Student.grade, stringifier: .default)
    let key2 = TitledKey(title: "Name", key: \Student.name , stringifier: .default )
   
    @Test func TypeErasureTest() async throws {
        
        
        let array = [AnySearchableKey(key) , AnySearchableKey(key2)]
        
        print(array[0].stringify(ali))
        print(array[1].stringify(ali))
    }
    
    @Test func SortErasureTest() async throws {
        
        let hamid = Student(name: "Hamid", age: 34, grade: 85.5, birthDate: .now, family: .init(name: "somethingElse"))
        
        let studensts = [hamid,ali]
            
        let searchableName = SearchableKeyPath(key: \Student.family, stringifier: FamilyStringifier())
        let namePath = SortableKeyPath(\Student.name)
        
        let ageKeyPath = SortableKeyPath(\Student.age)
        //let ageKeyPath = SortableTitledKeyPath(title: "Age", key: \Student.age)
        
        let titledKey = TitledKey(title: "Name", key: namePath , stringifier: .default )
        
        let searcher = BackgroundSearcher(models: studensts, keys: [.init(titledKey)])
        
        let familyKey = TitledKey(title: "Family", key: \Student.family, stringer: FamilyStringifier())
        
        //This will cause compile-time error because family doesn't confrom to Comparable
        //let family = SortableKeyPath(\Student.family)
        
        //This will cause compile-time error because family doesn't confrom to Comparable
        //let errorSorter = AnySorter(familyKey,order: .init(from: .ascending))
        
                
         let sortedByAge = await AnySortableKey(ageKeyPath, order: .ascending).sorted(studensts)
        #expect(studensts[1] == sortedByAge[0])
        #expect(studensts[0] == sortedByAge[1])
        
        //These 2 defenitions provide the same result
        let sortedByName = await titledKey.sort(studensts, order: .descending)
        //let sortedByName = await AnySorter(namePath,order: .descending).sorted(studensts)
        #expect(studensts[0] == sortedByName[0])
        #expect(studensts[1] == sortedByName[1])
    }
    @Test func singleThreadSearchTest() async throws {
        let studnets : [Student] = [
            .init(name: "John", age: 20, grade: 12.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jane", age: 21, grade: 13.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jack", age: 22, grade: 14.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jill", age: 23, grade: 15.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "John", age: 24, grade: 16.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jane", age:25, grade: 17.5, birthDate: .now ,family:.init(name: "Potter"))
        ]
        
        let nameKey = TitledKey(title: "Name", key: \Student.name)
        let ageKey = TitledKey(title: "Age", key: \Student.age)
        
        let clock = ContinuousClock()
        let nameResultNil = await nameKey.search(in: studnets, for: "Jane")
        let ageResultNil = await ageKey.search(in: studnets, for: 27.description)
        
        let nameResult = try #require(nameResultNil)
        let ageResult = try #require(ageResultNil)
        #expect(nameResult.count == 2)
        #expect(ageResult.count == 0)
        
        
        
    }
    @Test func sortTest() async throws {
        let studnets : [Student] = [
            .init(name: "John", age: 20, grade: 12.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jane", age: 21, grade: 13.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jack", age: 22, grade: 14.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jill", age: 23, grade: 15.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "John", age: 24, grade: 16.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jane", age:25, grade: 17.5, birthDate: .now ,family:.init(name: "Potter"))
        ]
        
        let grade = TitledKey(title: "Grade", key: \Student.grade)
        let nameKey = SortableKeyPath(\Student.name)
        //let sortedArray = nameKey.sort(students, order: .ascending)
        let sortedArray = await grade.sort(studnets, order: .descending)
        
        let keys : [AnySortableKey] = [.init(grade,order: .descending) , .init(nameKey, order: .descending)]
        
        #expect(sortedArray[0].grade == 17.5)
        #expect(sortedArray.last!.grade == 12.5)
    }
    
    
    @Test("Single thread Search doens't find anything") func notfound()async throws{
        let studnets : [Student] = [
            .init(name: "John", age: 20, grade: 12.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jane", age: 21, grade: 13.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jack", age: 22, grade: 14.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jill", age: 23, grade: 15.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "John", age: 24, grade: 16.5, birthDate: .now ,family:.init(name: "Potter")),
            .init(name: "Jane", age:25, grade: 17.5, birthDate: .now ,family:.init(name: "Potter"))
        ]
        let nameKey = SearchableKeyPath(key:\Student.name)
        let ageKey = SearchableKeyPath(key:\Student.age)
     
        
        let searchResult = await ageKey.search(in:studnets , for: "Sara", strategy: .contains)
        
        #expect(searchResult == [])
    }
    @Test("Multi thread Search doens't find anything") func multythreadNotFound()async throws{
        //Creating a bigArray to search in
        let arrayCount = 100_500
        var bigArray : [Int] = []
        
        let maxRandNumber = arrayCount / 10
        
        for _ in 0..<arrayCount {
            let randomNumber = Int.random(in: 0..<maxRandNumber)
            bigArray.append(randomNumber)
        }
        
        
        let arrayKey = TitledKey(title: "Big Array", key: \Int.self, stringifier: .default)
        
        let searcher = BackgroundSearcher(models: bigArray , keys: [.init(arrayKey)])
        
   
        await searcher.setMaxNumberOfElementsInEachChunk(10000)
        
        let result = await searcher.search("-1")
        #expect(result == [])
    }
    @Test func multiThreadedSearch() async throws {
        
        //Creating a bigArray to search in
        let arrayCount = 100_500
        var bigArray : [Int] = []
        
        let maxRandNumber = arrayCount / 10
        
        for _ in 0..<arrayCount {
            let randomNumber = Int.random(in: 0..<maxRandNumber)
            bigArray.append(randomNumber)
        }
        
        
        let arrayKey = TitledKey(title: "Big Array", key: \Int.self, stringifier: .default)
        
        let searcher = BackgroundSearcher(models: bigArray , keys: [.init(arrayKey)])
        
   
        await searcher.setMaxNumberOfElementsInEachChunk(10000)
        
        let clock = ContinuousClock()
        let result = await clock.measure {
            
            
            let searchTerm = bigArray.randomElement()!.description
            let results = await searcher.search(searchTerm) ?? []
            #expect(results.count > 1)
        }
        logger.info("Search took \(result.description) for \(bigArray.count) elements.")
        
    }
    
    ///This test might fail depending on how fast your device can proccess this job
    @Test("Testing search cancellation") func cancelationTest() async throws {
        //Creating a bigArray to search in
        let arrayCount = 1_005_000
        var bigArray : [Int] = []
        
        let maxRandNumber = arrayCount / 10
        
        for _ in 0..<arrayCount {
            let randomNumber = Int.random(in: 0..<maxRandNumber)
            bigArray.append(randomNumber)
        }
        
        
        
        let arrayKey = TitledKey(title: "Big Array", key: \Int.self, stringifier: .default)
        
        let searcher = BackgroundSearcher(models: bigArray , keys: [.init(arrayKey)])
        
        
        await searcher.setMaxNumberOfElementsInEachChunk(10000)
        
        
        //Passing first search term
        async let firstResult = searcher.search(bigArray.randomElement()!.description)
        
        
      
        
        sleep(2)
        
        async let secondResult = searcher.search(bigArray.randomElement()!.description)
       
        await #expect(secondResult != nil )
        await #expect(firstResult == nil )
       
        
    }
    
    @Test("Test different SearchStrategy s") func searchStrategyTest() async throws {
        
        let names = ["Mohammad" , "Mohsen" , "Ali" , "Mohammad Amin"]
        
        let nameKey = TitledKey(title: "Name", key: \String.self)
        
        let results = await nameKey.search(in: names, for: "Moh", strategy: .contains)
        let unwrapped = try  #require(results)
        #expect(unwrapped.count == 3)
        
        let results2 = await nameKey.search(in: names, for: "Mohammad", strategy: .prefix)
        let unwrapped2 = try #require(results2)
        #expect(unwrapped2.count == 2)
        
        let results3 = await nameKey.search(in: names, for: "Mohammad", strategy: .exact)
        let unwrapped3 = try #require(results3)
        #expect(unwrapped3.count == 1)
    }
}
