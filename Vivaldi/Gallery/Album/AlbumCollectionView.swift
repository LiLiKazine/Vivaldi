//
//  AlbumCollectionView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/12.
//

import SwiftUI
import SwiftData

struct AlbumCollectionView: View {
    
    @Query(sort: \Album.date) private var albums: [Album]
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.photoInteractor) private var photoInteractor
    
    @State private var presentAlbumCreationSheet: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ScrollHGrid(rows: rows, alignment: .top, spacing: 8) {
                
                WrappedAlbumView(album: nil)
                
                ForEach(albums) { album in
                    WrappedAlbumView(album: album)
                }
            }
        }
        .padding()
        .sheet(isPresented: $presentAlbumCreationSheet, title: "Create album", hint: "name") { name in
            saveAlbum(with: name)
        }
        .navigationDestination(for: Album?.self) { album in
            ShowcaseView(album: album)
                .environment(\.modelContext, modelContext)
                .environment(\.photoInteractor, photoInteractor)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    presentAlbumCreationSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func saveAlbum(with name: String) {
        photoInteractor?.create(albumWithName: name)
    }
}

extension AlbumCollectionView {
    private var rowCount: Int { 2 }
    private var rows: [GridItem] { Array(0..<rowCount).map { _ in GridItem(.fixed(100), spacing: 8) } }
}

private struct WrappedAlbumView: View {
    
    let album: Album?
    
    @State private var isRenaming: Bool = false
    
    @Environment(\.photoInteractor) private var photoInteractor
    
    var body: some View {
        NavigationLink(value: Optional.some(album)) {
            Menu {
                Button("Rename") {
                    isRenaming = true
                }
                .disabled(album == nil)
                Button("Delete", role: .destructive) {
                    if let album {
                        photoInteractor?.delete(album: album)
                    }
                }
                .disabled(album == nil)
            } label: {
                AlbumView(album: album)
            }
        }
        .sheet(
            isPresented: $isRenaming,
            title: "Edit name",
            hint: album?.name ?? "new name"
        ) { name in
            guard let album, let photoInteractor else {
                return
            }
            photoInteractor.change(keypath: \.name, value: name, of: album)
        }
    }
    
}

#Preview {
    AlbumCollectionView()
}
