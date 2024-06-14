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
        VStack(alignment: .leading) {
            if let lastPhoto = album?.photos.last {
                Thumbnail(photo: lastPhoto)
            } else {
                Image(systemName: "rectangle.stack.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Text(album?.name ?? "All")
                .truncationMode(.middle)
            
            Text(album?.photoCountStr ?? "-")
                .font(.caption)
        }
        .frame(width: 100)
    }
}

#Preview {
    AlbumView(album: .init())
}
