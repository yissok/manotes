import Foundation
import SwiftData



func addTag(_ itemTag: String,_ parent: Tag?, _ context: ModelContext) {
    print("adding tag")
    let item = Tag(name: itemTag, parent: parent)
    context.insert(item)
}

func addNote(_ itemTag: String, _ itemValue: String, _ context: ModelContext,_ tags: [Tag]) {
    print("adding note")
    let existingTag = tags.filter { $0.name.elementsEqual(itemTag) }.first ?? nil
    let newNote = Note2(noteContent: itemValue, parent: existingTag)
    context.insert(newNote)
}

func deleteTag(_ item: Tag, _ context: ModelContext) {
    print("deleting note")
    context.delete(item)
}

func deleteItem(_ item: Note2, _ context: ModelContext) {
    print("deleting note")
    context.delete(item)
}
