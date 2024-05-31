//
//  ContentView.swift
//  manotes
//
//  Created by andrea on 30/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var content:String = ""
    var shtctcall = "shortcuts://run-shortcut?name=manoteSHTCT&input=U2FsdGVkX19Q9jDIsdqtAWE8aO/BgSRaQPgn2XHcd90="
    //https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
//    var shtctcall = "shortcuts://x-callback-url/run-shortcut?name=manoteSHTCT&input=U2FsdGVkX19Q9jDIsdqtAWE8aO/BgSRaQPgn2XHcd90=&x-error="+appNameUrl+"://&x-cancel="+appNameUrl+"://&x-success="+appNameUrl+"://"
    var body: some View {
        Label("hi", systemImage: "bolt.fill")
        TabView {
            VStack {
                TextEditor(text: $content)
                    .border(.green)
                Button(action: {
                    let shortcut = URL(string: shtctcall)!
                    UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
                }) {
                  HStack{
                    Text("send back to shortcut")
                  }
                  .padding()
                  .foregroundColor(Color.white)
                  .background(Color.blue)
                  .cornerRadius(8)
                  .shadow(radius: 8)
                }
                .padding()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "message")
            }
            .tag(1)
        }
//        .onAppear(perform: start)
        .onContinueUserActivity(UN_ID) { userActivity in
            content=""
            print("on continue")
        }
    }
    func start() {
        print("started main view")
        let shortcut = URL(string: shtctcall)!
        UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
    }
}
