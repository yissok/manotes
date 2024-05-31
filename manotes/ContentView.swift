//
//  ContentView.swift
//  manotes
//
//  Created by andrea on 30/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var content:String = ""
    //https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
    var shtctcall = "shortcuts://x-callback-url/run-shortcut?name=manoteSHTCT&input=U2FsdGVkX19Q9jDIsdqtAWE8aO/BgSRaQPgn2XHcd90=&x-error="+appNameUrl+"://&x-cancel="+appNameUrl+"://&x-success="+appNameUrl+"://"
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
        .onAppear(perform: start)
        .onContinueUserActivity(UN_ID) { userActivity in
            content=""
            print("on continue")
//            let intent = userActivity.interaction?.intent as? RCliteIntent
//            print(intent?.text)
//            content=intent?.text!
        }
    }
    func start() {
        print("started main view")
        let a = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        let aa = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""

        print(a)
        print(aa)
        
//        if (defaults.value(forKey:CONTENT_PASSED) != nil) {
//            content = defaults.string(forKey:CONTENT_PASSED)!
//        }
//        print(defaults.value(forKey:CONTENT_PASSED))
        let shortcut = URL(string: shtctcall)!
        UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
    }
}
