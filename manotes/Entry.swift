import Foundation
import SwiftData

@Model
class Entry: Identifiable {
    var id: String
    var name: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
}



func addItem(_ itemValue: String, _ context: ModelContext) {
    print("adding item")
    let item = Entry(name: itemValue)
    context.insert(item)
}

//func updateItem(_ item: Entry, _ context: ModelContext) {
//    print("editing item")
//    item.name = "updated"
//    try? context.save()
//}

func deleteItem(_ item: Entry, _ context: ModelContext) {
    print("deleting item")
    context.delete(item)
}
