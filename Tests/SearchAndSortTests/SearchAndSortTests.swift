import Testing
import Foundation
@testable import SearchAndSort

struct Family{
    let name  : String
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
        let ageKeyPth = SortableKeyPath(\Student.age)
        let titelSortableKeyPath = SortableTitledKeyPath(title: "Age", key: \Student.age)
        
        let titledKey = TitledKey(title: "Name", key: namePath , stringifier: .default )
        
        
        //This will cause compile-time error cause family doesn't confrom to Comparable
        //let family = SortableKeyPath(\Student.famila)
        
        let sorter = Sorter<Student>()
        
        let sortByAge = await sorter.sort(studensts, by: .init(titelSortableKeyPath, order: .ascending) )
        #expect(studensts[1] == sortByAge[0])
        #expect(studensts[0] == sortByAge[1])
        
        let sortByName = await sorter.sort(studensts, by: .init(namePath,order: .descending))
        #expect(studensts[0] == sortByName[0])
        #expect(studensts[1] == sortByName[1])
    }
}
