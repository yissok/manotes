import Foundation
import SwiftData



func addTag(_ itemTag: String, _ context: ModelContext) {
    print("adding tag")
    let item = Tag(name: itemTag)
    context.insert(item)
}

func addNote(_ itemTag: String, _ itemValue: String, _ context: ModelContext) {
    print("adding note")
    let item = Note2(name: itemValue, tag: itemTag)
    context.insert(item)
}

//func updateItem(_ item: Entry, _ context: ModelContext) {
//    print("editing item")
//    item.name = "updated"
//    try? context.save()
//}

func deleteTag(_ item: Tag, _ context: ModelContext) {
    print("deleting note")
    context.delete(item)
}

func deleteItem(_ item: Note2, _ context: ModelContext) {
    print("deleting note")
    context.delete(item)
}
