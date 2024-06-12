//
//  GalleryView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//

import SwiftUI
import SwiftData

struct GalleryView: View {
    
    
    var body: some View {
        
         content()
            .navigationTitle("Albums")
            
    }
    
    @ViewBuilder func content() -> some View {
        AlbumCollectionView()
    }
}

#Preview {
    GalleryView()
}
