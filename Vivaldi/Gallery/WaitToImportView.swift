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
    
    @Environment(\.photoInteractor) private var photoInteractor
    
    @State private var items: [PhotosPickerItem] = []
    
    let hint: String
    let maxSelectionCount: Int?
    let matching: PHPickerFilter?
    
    init(hint: String, maxSelectionCount: Int? = 99, matching: PHPickerFilter? = .images) {
        self.hint = hint
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
            photoInteractor?.onPick(items: newValue)
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
    WaitToImportView(hint: "Import from album")
}


