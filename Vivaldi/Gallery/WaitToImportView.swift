//
//  WaitToImportView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//

import SwiftUI
import PhotosUI

struct WaitToImportView: View {
    
    @State private var items: [PhotosPickerItem] = []
    
    let hint: String
    let inserter: AlbumItemInserter
    let maxSelectionCount: Int?
    let matching: PHPickerFilter?
    
    init(hint: String, inserter: AlbumItemInserter, maxSelectionCount: Int? = 99, matching: PHPickerFilter? = .images) {
        self.hint = hint
        self.inserter = inserter
        self.maxSelectionCount = maxSelectionCount
        self.matching = matching
    }
    
    var body: some View {
        PhotosPicker(
            hint,
            selection: $items,
            maxSelectionCount: maxSelectionCount,
            selectionBehavior: .ordered,
            matching: matching,
            photoLibrary: .shared()
        )
        .onChange(of: items) { _, newValue in
            if newValue.isEmpty { return }
            Task {
                do {
                    try await inserter.insert(loadable: newValue)
                } catch {
                    print("Insert failed: \(error)")
                }
            }
            self.items.removeAll()
        }
    }
}

extension PhotosPickerItem: ContentReadable {}

extension PhotosPickerItem: TransferableLoadable {
    func load<T>(type: T.Type) async throws -> T? where T : Transferable {
        return try await loadTransferable(type: type)
    }
}

private class MockInserter: AlbumItemInserter {
    func insert(loadable items: [ContentReadable & TransferableLoadable]) async throws {
        print("insert \(items.count) items")
    }
}

#Preview {
    WaitToImportView(hint: "Import from album", inserter: MockInserter())
}


