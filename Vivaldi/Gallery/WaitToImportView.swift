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
    
    let inserter: AlbumItemInserter
    let maxSelectionCount: Int?
    let matching: PHPickerFilter?
    
    init(inserter: AlbumItemInserter, maxSelectionCount: Int? = 99, matching: PHPickerFilter? = .images) {
        self.inserter = inserter
        self.maxSelectionCount = maxSelectionCount
        self.matching = matching
    }
    
    var body: some View {
        VStack {
            PhotosPicker(
                "Import assets from album",
                selection: $items,
                maxSelectionCount: maxSelectionCount,
                selectionBehavior: .ordered,
                matching: matching
            )
        }
        .onChange(of: items) { _, newValue in
            Task {
                do {
                    try await inserter.insert(loadable: newValue)
                } catch {
                    print("Insert failed: \(error)")
                }
            }
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
    WaitToImportView(inserter: MockInserter())
}


