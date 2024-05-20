//
//  ThumbnailView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI

protocol ThumbnailPresentable {
    
    var image: Image { get }
}

struct ThumbnailView: View {
    
    let thumbnail: ThumbnailPresentable

    var body: some View {

        thumbnail.image

    }
}

#Preview {
    ThumbnailView(thumbnail: MockThumbnail())
}

private class MockThumbnail: ThumbnailPresentable {
    var image: Image { .init(systemName: "doc.text.image") }
}
