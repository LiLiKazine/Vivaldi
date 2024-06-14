//
//  Widgets.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/13.
//

import SwiftUI


private struct InputSheet: View {
    
    @Binding var isPresented: Bool
    let title: LocalizedStringKey
    let hint: LocalizedStringKey
    let onConfirm: (String) -> Void

    @State private var input = ""

    var body: some View {
        VStack {
            Text(title)
            TextField(hint, text: $input)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            Button {
                onConfirm(input)
                isPresented = false
            } label: {
                 Text("Confirm")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(input.isEmpty)
            Button {
                isPresented = false
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}


extension View {
    
    func sheet(isPresented: Binding<Bool>, title: LocalizedStringKey, hint: LocalizedStringKey, onConfirm: @escaping (String) -> Void) -> some View {
        
        self.sheet(isPresented: isPresented) {
            InputSheet(isPresented: isPresented, title: title, hint: hint, onConfirm: onConfirm)
                .presentationDetents([.height(200)])
        }
        
    }
    
}
