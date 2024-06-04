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
        
        ShowCaseContainer(data: photos) { photo in
            Thumbnail(photo: photo)
                .onTapGesture {
                    preview(photo: photo)
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

private struct ShowCaseContainer<Data, Item>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Item: View {
    
    let data: Data
    let columnCount: Int = 3
    let item: (Data.Element) -> Item
    
    var columns: [GridItem] { Array(0..<3).map { _ in GridItem() } }
    
    var body: some View {
        ScrollVGrid(columns: columns) {
            ForEach(data) { item($0) }
        }
    }
}


#Preview {
    ShowcaseView(photos: [])
}
