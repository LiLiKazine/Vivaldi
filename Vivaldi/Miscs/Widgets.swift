//
//  Widgets.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/13.
//

import SwiftUI


private struct InputSheet<Item>: View where Item: Identifiable {
    
    @Binding var item: Item?
    let attributes: (Item) -> (title: String, hint: String)
    let onConfirm: (String, Item) -> Void
    
    @State private var input = ""
    
    init(
        item: Binding<Item?>,
        attributes: @escaping (Item) -> (title: String, hint: String),
        onConfirm: @escaping (String, Item) -> Void
    ) {
        self._item = item
        self.attributes = attributes
        self.onConfirm = onConfirm
    }

    var body: some View {
        let (title, hint): (String, String) = {
            if let item {
                return attributes(item)
            }
            return ("", "")
        }()
        VStack {
            Text(title)
            TextField(hint, text: $input)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            Button {
                onConfirm(input, item!)
                item = nil
            } label: {
                 Text("Confirm")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(input.isEmpty)
            Button {
                item = nil
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}



extension InputSheet where Item == BoolWrapper {
    
    init(isPresented: Binding<Bool>, title: String, hint: String, onConfirm: @escaping (String) -> Void) {
        self.init(
            item: .init(
                get: { BoolWrapper(id: isPresented.wrappedValue) },
                set: { wrapper in isPresented.wrappedValue = wrapper?.id ?? false }
            ),
            attributes: { _ in
                return (title, hint)
            },
            onConfirm: { name, _ in onConfirm(name) }
        )

    }
}


private struct BoolWrapper: Identifiable {
    let id: Bool
}


//MARK: - View Extension
extension View {
    
    func sheet(isPresented: Binding<Bool>, title: String, hint: String, onConfirm: @escaping (String) -> Void) -> some View {
        self.sheet(isPresented: isPresented) {
            InputSheet(isPresented: isPresented, title: title, hint: hint, onConfirm: onConfirm)
                .presentationDetents([.height(200)])
        }
    }
    
    func sheet<Item>(item: Binding<Item?>, attributes: @escaping (Item) -> (title: String, hint: String), onConfirm: @escaping (String, Item) -> Void) -> some View where Item: Identifiable {
        self.sheet(item: item) { _ in
            InputSheet(item: item, attributes: attributes, onConfirm: onConfirm)
                .presentationDetents([.height(200)])
        }
    }
    
}
