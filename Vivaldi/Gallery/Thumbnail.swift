//
//  Thumbnail.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import SwiftUI
import ImageKit

protocol ThumbnailRendererView: View {
    associatedtype Context
    static func create(from context: Context) -> Self
}

struct Thumbnail<Content>: View where Content: ThumbnailRendererView {
    
    private let context: Content.Context
    
    init(context: Content.Context) {
        self.context = context
    }
    
    var body: some View {
        VStack {
            Content.create(from: context)
                .frame(height: 100)

        }
    }
}

struct ImageThumbnail {
    
    let photo: Photo
    
    var body: some View {
        VStack {
            IKImage(retriver: photo.retriver())
                .resizable()
            Text(photo.name)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
    
}
extension ImageThumbnail : ThumbnailRendererView {
    static func create(from context: Photo) -> ImageThumbnail {
        ImageThumbnail(photo: context)
    }
}

extension Thumbnail where Content == ImageThumbnail {
    init(photo: Photo) {
        self.init(context: photo)
    }
}

#Preview {
    Thumbnail(photo: Photo(name: "", relativePath: ""))
}
