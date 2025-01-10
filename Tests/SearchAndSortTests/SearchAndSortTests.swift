import Testing
import Foundation
@testable import SearchAndSort


struct Student : Identifiable , Equatable {
    let id = UUID()
    let name : String
    let age : Int
    let grade : Double
    let birthDate : Date
}

struct Person {
    let name : String
}
struct Tests {
    let ali = Student(name: "Ali", age: 12, grade: 12.4, birthDate: Date())
    
    
    let key = TitledKey(title: "Grade", key: \Student.grade, stringifier: .default)
    let key2 = TitledKey(title: "Name", key: \Student.name , stringifier: .default )
//    let key3 = TitledKey(title: "BirthDate", key: \Student.birthDate , stringifier: )
//    @Test func doubleTest() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//        
// 
//        let stringed = key.stringify(ali)
//        #expect(stringed.contains("12.4"))
//       // #expect(stringed.contains("۱۲.۴"))
//    }
//    @Test func intTest() async throws {
//        let key = TitledKey(title: "Grade", key: \Student.age)
//       
//        
//        let stringed = key.stringify(ali)
//        #expect(stringed.contains("12"))
//
//    }
    @Test func TypeErasureTest() async throws {
        
        
        let array = [AnySearchableKey(key) , AnySearchableKey(key2)]
        
        print(array[0].stringify(ali))
        print(array[1].stringify(ali))
    }
    
    @Test func SortErasureTest() async throws {
        
        let hamid = Student(name: "Hamid", age: 34, grade: 85.5, birthDate: .now)
        
        let studensts = [hamid,ali]
            
        let namePath = SortableKeyPath(\Student.name)
        let ageKeyPth = SortableKeyPath(\Student.age)
        let sortableKeys = [AnySorter(namePath,order: .descending) , AnySorter(ageKeyPth , order: .ascending)]
        
        let sortByAge = await sortableKeys[1].sorted(studensts)
        #expect(studensts[0] == sortByAge[0])
        #expect(studensts[1] == sortByAge[1])
        
        let sortByName = await sortableKeys[0].sorted(studensts)
        #expect(studensts[1] == sortByName[0])
        #expect(studensts[0] == sortByName[1])
    }
}
