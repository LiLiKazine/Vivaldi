//
//  EditText.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import SwiftUI

struct EditText: View {
    
    @Binding var isEditing: Bool
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Group {
            if isEditing {
                TextField("", text: $text)
                    .focused($isFocused)
            } else {
                Text(text)
            }
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
    }
}

#Preview {
    EditText(isEditing: .constant(false), text: .constant("测试"))
}
