//
//  ShowcaseView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI

private let COLUMNS = [GridItem(), GridItem(), GridItem()]

struct ShowcaseView: View {
    
    let photos: [Photo]
    
    @State private var previewURL: URL?
    var urlList: [URL] { photos.previewURLs() }
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(
                columns: COLUMNS,
                alignment: .center
            ) {
                ForEach(photos) { photo in
                    VStack {
                        Thumbnail(photo: photo)
                            .onTapGesture {
                                preview(photo: photo)
                            }
                            
                        Text(photo.name)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                    }
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
    ShowcaseView(photos: [])
}
