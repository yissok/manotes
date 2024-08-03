import SwiftUI

struct BigButton: View {
    @Environment(\.colorScheme) var colorScheme
    let height:CGFloat=60
    let fontSz:CGFloat=20
    let content:String
    let bgColor:Color?
    var body: some View {
        Text(content)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .font(Font.system(size: fontSz, design: .monospaced))
            .background(bgColor == nil ? Color(.systemBackground) : bgColor)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .cornerRadius(8)
    }
}
