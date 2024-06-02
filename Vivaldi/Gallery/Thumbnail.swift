//
//  Thumbnail.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import SwiftUI

struct Thumbnail<Content, Context>: View where Content: View {
    
    private let content: (Context) -> Content
    private let context: Context
    
    init(@ViewBuilder content: @escaping (Context) -> Content, context: Context) {
        self.content = content
        self.context = context
    }
    
    var body: some View {
        content(context)
    }
}

extension Thumbnail<IKImage, Photo> {
    
    init(photo: Photo) {
        self.init(content: { photo in
            IKImage(source: photo.create())
                .resizable()
        }, context: photo)
    }
}

#Preview {
    Thumbnail(photo: Photo(name: "", relativePath: ""))
}
