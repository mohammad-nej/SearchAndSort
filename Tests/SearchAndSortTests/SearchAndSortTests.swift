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
            
        let namePath = SortableKeyPath(\Student.name)
        
        let ageKeyPath = SortableKeyPath(\Student.age)
        //let ageKeyPath = SortableTitledKeyPath(title: "Age", key: \Student.age)
        
        let titledKey = TitledKey(title: "Name", key: namePath , stringifier: .default )
        
        let familyKey = TitledKey(title: "Family", key: \Student.family, stringer: FamilyStringifier())
        
        //This will cause compile-time error because family doesn't confrom to Comparable
        //let family = SortableKeyPath(\Student.family)
        
        //This will cause compile-time error because family doesn't confrom to Comparable
        //let errorSorter = AnySorter(familyKey,order: .init(from: .ascending))
        
                
         let sortedByAge = await AnySorter(ageKeyPath, order: .ascending).sorted(studensts)
        #expect(studensts[1] == sortedByAge[0])
        #expect(studensts[0] == sortedByAge[1])
        
        //These 2 defenitions provide the same result
        let sortedByName = await titledKey.sort(studensts, order: .descending)
        //let sortedByName = await AnySorter(namePath,order: .descending).sorted(studensts)
        #expect(studensts[0] == sortedByName[0])
        #expect(studensts[1] == sortedByName[1])
    }
    
    @Test func multiThreadedSearch() async throws {
        
        //Creating a bigArray to search in
        let arrayCount = 100_500
        var bigArray : [Int] = []
        
        let maxRandNumber = arrayCount / 10
        
        for index in 0..<arrayCount {
            let randomNumber = Int.random(in: 0..<maxRandNumber)
            bigArray.append(randomNumber)
        }
        
        let test = TitledKey(title: "Big Array", key: \Int.self)
        
        
        
        
        //
        
        let arrayKey = TitledKey(title: "Big Array", key: \Int.self, stringifier: .default)
        
        var searcher = BackgroundSearcher(models: bigArray , keys: [.init(arrayKey)])
        
        await searcher.setMaxNumberOfElementsInEachChunk(10000)
        
        let clock = ContinuousClock()
        let result = await clock.measure {
            
            
            let searchTerm = bigArray.randomElement()!.description
            let results = await searcher.search(searchTerm) ?? []
            #expect(results.count > 1)
        }
        logger.info("Search took \(result.description) for \(bigArray.count) elements.")
        
    }
}
