//
//  AppIntent.swift
//  manotes
//
//  Created by andrea on 05/08/24.
//

import Foundation
import Intents

class AppIntent{
    class func allowSiri() {
        INPreferences.requestSiriAuthorization { status in
            switch status {
            case .notDetermined,
                    .restricted,
                    .denied: print("siri err")
            case .authorized:print("siri ok")
            }
        }
    }
    
    class func inputF(){
        let intent = InputIntent()
        intent.suggestedInvocationPhrase = "Get Input"
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate{ error in
            if let error = error as NSError? {
                print("int failed: \(error.description)")
            }else{
                print("succ int")
            }
        }
    }
}
