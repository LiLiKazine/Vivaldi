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
    
    @State private var presentAlbumCreationAlert: Bool = false
    @State private var albumCreationName = ""
    
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
        .alert("Create Album", isPresented: $presentAlbumCreationAlert, actions: {
                TextField("name", text: $albumCreationName)
                Button("Confirm") {
                    saveAlbum(with: albumCreationName)
                    albumCreationName = ""
                }
                .disabled(albumCreationName.isEmpty)
                Button("Cancel") {
                    albumCreationName = ""
                }
        })
        .navigationDestination(for: Album?.self) { album in
            ShowcaseView(album: album)
                .environment(\.modelContext, modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "plus")
                    .onTapGesture {
                        presentAlbumCreationAlert = true
                    }
            }
        }
    }
    
    private func saveAlbum(with name: String) {
        
    }
}

extension AlbumCollectionView {
    private var rowCount: Int { 2 }
    private var rows: [GridItem] { Array(0..<rowCount).map { _ in GridItem(.fixed(100), spacing: 8) } }
}

#Preview {
    AlbumCollectionView()
}
