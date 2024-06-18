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
    
    @Environment(\.photoInteractor) private var photoInteractor
    @Environment(UIConfiguration.self) private var uiConfiguration
    
    var body: some View {
        Group {
            if let album {
                PhotoInAlbumShowcaseView(album: album)
                    .navigationTitle(album.name)
            } else {
                AllPhotoShowcaseView()
                    .navigationTitle("All")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                WaitToImportView { items in
                    photoInteractor?.onPick(items: items, in: album, thumbnailHeight: uiConfiguration.photoFrameSize.height)
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
    
    private var columnCount: Int { uiConfiguration.photoColumns }
    private var columns: [GridItem] { Array(0..<columnCount).map { _ in GridItem() } }
    
    @Environment(UIConfiguration.self) private var uiConfiguration
    @Environment(\.photoInteractor) private var photoInteractor

    var body: some View {
        ScrollVGrid(columns: columns) {
            ForEach(photos) { photo in
                Menu {
                    Button("Delete", role: .destructive) {
                        photoInteractor?.delete(photo: photo)
                    }
                } label: {
                    VStack {
                        Thumbnail(photo: photo)
                        EditText(photo.name) { name in
                            photoInteractor?.change(keypath: \.name, value: name, of: photo)
                        }
                        .lineLimit(1)
                        .truncationMode(.middle)
                    }
                } primaryAction: {
                    preview(photo: photo)
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
