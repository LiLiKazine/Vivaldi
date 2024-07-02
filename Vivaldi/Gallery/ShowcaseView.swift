//
//  ShowcaseView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI
import QuickLook
import SwiftData
import ImageKit

struct ShowcaseView: View {
    
    let album: Folder?
    
    @State private var currentPlaying = PlayingVideo.shared
    
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
        .environment(currentPlaying)
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
    @Query(sort: \Document.date) private var documents: [Document]
    var body: some View {
        ShowCaseContainer(documents: documents)
            .task {
                print(documents)
            }
    }
}

private struct PhotoInAlbumShowcaseView: View {
    let album: Folder
    var body: some View {
        ShowCaseContainer(documents: album.documents)
    }
}

private struct ShowCaseContainer: View {
    
    let documents: [Document]
    
    @State private var renamingDoc: Document?
    @State private var previewURL: URL?
    private var urlList: [URL] { documents.previewURLs() }
    
    private var columnCount: Int { uiConfiguration.photoColumns }
    private var columns: [GridItem] { Array(0..<columnCount).map { _ in GridItem() } }
    
    @Environment(UIConfiguration.self) private var uiConfiguration
    @Environment(\.photoInteractor) private var photoInteractor

    var body: some View {
        ScrollVGrid(columns: columns) {
            ForEach(documents) { document in
                Menu {
                    Button("Rename") {
                        renamingDoc = document
                    }
                    Button("Delete", role: .destructive) {
                        photoInteractor?.delete(document: document)
                    }
                } label: {
                    VStack {
                        Thumbnail(document: document)
                        Text(document.name)
                            .frame(height: 22)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundStyle(.black)
                    }
                } primaryAction: {
                    preview(document: document)
                }

            }
        }
        .padding()
        .quickLookPreview($previewURL, in: urlList)
        .sheet(
            item: $renamingDoc,
            attributes: { document in
                return ("Edit name", document.name)
            },
            onConfirm: { name, document in
                photoInteractor?.change(keypath: \.name, value: name, of: document)
            }
        )
    }
    
    private func preview(document: Document) {
        do {
            previewURL = try document.savingURL()
        } catch {
            print(error)
        }
    }
}


#Preview {
    ShowcaseView(album: nil)
        .modelContainer(LocalContainer.sharedContainer)
        .environment(\.photoInteractor, LocalContainer.sharedPhotoInteractor)
        .environment(UIConfiguration.shared)
}
