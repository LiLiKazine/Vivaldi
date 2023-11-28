//
//  AuthView.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/27.
//

import SwiftUI
import LocalAuthentication

struct AuthView: View {
    
    @EnvironmentObject var lockState: LockState
    
    var body: some View {
        Text("Auth")
            .onAppear {
                authenticate()
            }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        let reason = "We need to unlock your data."
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                lockState.isLocked = !success
            }
        }
    }
    
}
