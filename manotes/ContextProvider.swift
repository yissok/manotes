import SwiftUI
import SwiftData
import Combine

class ContextProvider: ObservableObject {
    @Published var context: ModelContext?

    init(context: ModelContext?) {
        self.context = context
    }
}
