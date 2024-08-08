
import Foundation
import SwiftUI

func callShortcutWith(_ itemValue: String) {
    print("calling shortcut")
    let shortcut = URL(string: shtctcall+itemValue)!
    UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
}
