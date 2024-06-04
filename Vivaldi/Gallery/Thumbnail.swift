//
//  Thumbnail.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import SwiftUI
import ImageKit
import QuickLook

struct Thumbnail<Content, Context>: View where Content: View {
    
    private let content: (Context) -> Content
    private let context: Context
    
    init(@ViewBuilder content: @escaping (Context) -> Content, context: Context) {
        self.content = content
        self.context = context
    }
    
    var body: some View {
        content(context)
            .frame(height: 100)

    }
}

extension Thumbnail<IKImage, Photo> {
    
    init(photo: Photo) {
        self.init(content: { photo in
            IKImage(retriver: photo.retriver())
                .resizable()
        }, context: photo)
    }
}

#Preview {
    Thumbnail(photo: Photo(name: "", relativePath: ""))
}
