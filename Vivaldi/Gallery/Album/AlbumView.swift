//
//  AlbumView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/12.
//

import SwiftUI

struct AlbumView: View {
    
    let album: Album?
    
    var body: some View {
        VStack {
            if let lastPhoto = album?.photos.last {
                Thumbnail(photo: lastPhoto)
            } else {
                Image(systemName: "rectangle.stack.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Text(album?.name ?? "All")
            
            if let count = album?.photos.count {
                Text(String(count))
                    .font(.caption)
            }
        }
    }
}

#Preview {
    AlbumView(album: .init())
}
