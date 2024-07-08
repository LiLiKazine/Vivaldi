//
//  AlbumView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/12.
//

import SwiftUI

struct AlbumView: View {
    
    let album: Folder?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let last = album?.documents.last {
                Thumbnail(document: last)
            } else {
                Image(systemName: "rectangle.stack.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Text(album?.name ?? "All")
                .truncationMode(.middle)
//                .foregroundStyle(.black)
            
            Text(album?.docCountStr ?? "-")
                .font(.caption)
//                .foregroundStyle(.gray)
        }
        .frame(width: 100)
    }
}

#Preview {
    AlbumView(album: .init())
}
