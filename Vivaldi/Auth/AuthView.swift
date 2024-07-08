//
//  AuthView.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/27.
//

import SwiftUI
import LocalAuthentication

struct AuthView: View {
    
    @Environment(LockState.self) var lockState
    
    var body: some View {
        ZStack {
            Color.black
            Image(systemName: "face.smiling")
                .border(.red)
                .onTapGesture {
                    authenticate()
                }
                .task {
                    try? await Task.sleep(for: .milliseconds(200))
                    authenticate()
                }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        let reason = "We need to unlock your data."
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                lockState.isLocked = !success
                print(success, authenticationError.debugDescription)
                if !success || authenticationError != nil {
                    //TODO: toast error
                }
            }
        } else {
            lockState.isLocked = true
            print("Can't evaluate policy", error.debugDescription)
        }
    }
    
}
