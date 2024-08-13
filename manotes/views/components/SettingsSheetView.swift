//
//  SheetView.swift
//  manotes
//
//  Created by andrea on 13/08/24.
//

import SwiftUI



struct SettingsSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        Button("Export", action: exportTree)
            .font(.title)
            .padding()
        Button("Import", action: importTree)
            .font(.title)
            .padding()
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
    }
    
    
    func exportTree() { }
    func importTree() { }
}
