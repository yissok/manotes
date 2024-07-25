

import SwiftUI

struct deletePlayground: View {
    @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Items")
                .toolbar {
                    EditButton()
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
