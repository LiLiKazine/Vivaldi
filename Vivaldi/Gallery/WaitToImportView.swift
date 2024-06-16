//
//  WaitToImportView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//

import SwiftUI
import PhotosUI
import SwiftData

struct WaitToImportView: View {
        
    @State private var items: [PhotosPickerItem] = []
    
    let maxSelectionCount: Int?
    let matching: PHPickerFilter?
    let onSelected: ([PhotosPickerItem]) -> Void
    
    init(
        maxSelectionCount: Int? = nil,
        matching: PHPickerFilter? = .images,
        onSelected: @escaping ([PhotosPickerItem]) -> Void
    ) {
        self.maxSelectionCount = maxSelectionCount
        self.matching = matching
        self.onSelected = onSelected
    }
    
    var body: some View {
        PhotosPicker(
            selection: $items,
            maxSelectionCount: maxSelectionCount,
            selectionBehavior: .ordered,
            matching: matching,
            photoLibrary: .shared()
        ) {
            Image(systemName: "plus")
        }
        .onChange(of: items) { _, newValue in
            if newValue.isEmpty { return }
            onSelected(newValue)
            self.items.removeAll()
        }
    }
}

extension PhotosPickerItem: LoadableTranferable {
    func load<T>(type: T.Type) async throws -> T? where T : Transferable {
        return try await loadTransferable(type: type)
    }
}

#Preview {
    WaitToImportView { _ in }
}


