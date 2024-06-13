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
                NavigationLink(value: Optional.some(Optional<Album>.none)) {
                    AlbumView(album: nil)
                }
                
                ForEach(albums) { album in
                    NavigationLink(value: Optional.some(album)) {
                        AlbumView(album: album)
                    }
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
                Image(systemName: "plus")
                    .onTapGesture {
                        presentAlbumCreationSheet = true
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

#Preview {
    AlbumCollectionView()
}
