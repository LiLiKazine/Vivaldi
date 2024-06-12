//
//  ShowcaseView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI
import QuickLook
import SwiftData

struct ShowcaseView: View {
    
    let album: Album?
    
    var body: some View {
        
        if let album {
            PhotoInAlbumShowcaseView(album: album)
                .navigationTitle(album.name)
        } else {
            AllPhotoShowcaseView()
                .navigationTitle("All")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "plus")
                            .onTapGesture {
                                print("showcase")
                            }
                    }
                }
        }
    }
    
   
}

private struct AllPhotoShowcaseView: View {
    @Query(sort: \Photo.date) private var photos: [Photo]
    var body: some View {
        ShowCaseContainer(photos: photos)
    }
}

private struct PhotoInAlbumShowcaseView: View {
    let album: Album
    var body: some View {
        ShowCaseContainer(photos: album.photos)
    }
}

private struct ShowCaseContainer: View {
    
    let photos: [Photo]
    
    @State private var previewURL: URL?
    private var urlList: [URL] { photos.previewURLs() }
    
    private let columnCount: Int = 3
    private var columns: [GridItem] { Array(0..<columnCount).map { _ in GridItem() } }
    
    @Environment(\.photoInteractor) private var photoInteractor

    var body: some View {
        ScrollVGrid(columns: columns) {
            ForEach(photos) { photo in
                VStack {
                    Thumbnail(photo: photo)
                        .onTapGesture {
                            preview(photo: photo)
                        }
                    
                    EditText(photo.name) { name in
                        photoInteractor?.change(name: name, of: photo.id)
                    }
                    .lineLimit(1)
                    .truncationMode(.middle)
                }
            }
        }
        .padding()
        .quickLookPreview($previewURL, in: urlList)
    }
    
    private func preview(photo: Photo) {
        do {
            previewURL = try photo.savingURL()
        } catch {
            print(error)
        }
    }
}


#Preview {
    ShowcaseView(album: nil)
}
