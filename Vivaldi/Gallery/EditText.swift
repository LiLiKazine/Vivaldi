//
//  EditText.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import SwiftUI

struct EditText: View {
    
    let text: String
    let onSubmit: (String) -> Void
    
    init(_ text: String, onSubmit: @escaping (String) -> Void) {
        self.text = text
        self.onSubmit = onSubmit
        self.inputText = text
    }
    
    @State private var isEditing: Bool = false
    @State private var inputText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Group {
            if isEditing {
                TextField("", text: $inputText)
                    .focused($isFocused)
                    .onSubmit {
                        onSubmit(inputText)
                    }
            } else {
                Text(text)
            }
        }
        .frame(height: 22)
        .contentShape(Rectangle())
        .onTapGesture {
            isEditing = true
        }
        .onChange(of: isEditing) {  _, newValue in
            if isFocused != newValue {
                isFocused = newValue
            }
        }
        .onChange(of: isFocused) { _, newValue in
            if isEditing != newValue {
                isEditing = newValue
            }
        }
        .onChange(of: text) { _, newValue in
            inputText = newValue
        }
    }
}

#Preview {
    EditText("untitled") { _ in }
}
