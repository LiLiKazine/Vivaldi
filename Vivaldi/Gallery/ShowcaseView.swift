//
//  ShowcaseView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI
import QuickLook

struct ShowcaseView: View {
    
    let photos: [Photo]
    
    @State private var previewURL: URL?
    private var urlList: [URL] { photos.previewURLs() }
    private let columns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        
        container { photo in
            Thumbnail(photo: photo)
                .onTapGesture {
                    preview(photo: photo)
                }
        }
        .padding()
        .quickLookPreview($previewURL, in: urlList)
    }
    
    private func container<Item>(of item: @escaping (Photo) -> Item) -> some View where Item: View {
        ScrollVGrid(columns: columns) {
            ForEach(photos) { photo in
                item(photo)
            }
        }
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
    ShowcaseView(photos: [])
}
