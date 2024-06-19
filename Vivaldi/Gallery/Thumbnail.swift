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
        }
    }
}

struct ImageThumbnail {
    
    @Environment(\.photoInteractor) private var photoInteractor
    @Environment(UIConfiguration.self) private var uiConfiguration
    let document: Document
    
    var body: some View {
        Color.white
            .frame(
                width: uiConfiguration.photoFrameSize.width,
                height: uiConfiguration.photoFrameSize.height
            )
            .overlay {
                IKImage(retriver: document.retriver())
                    .backup(retriver: document.backupRetriver())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .clipped()
    }
    
}
extension ImageThumbnail : ThumbnailRendererView {
    static func create(from context: Document) -> ImageThumbnail {
        ImageThumbnail(document: context)
    }
}

extension Thumbnail where Content == ImageThumbnail {
    init(document: Document) {
        self.init(context: document)
    }
}

#Preview {
    Thumbnail(document: .init(photoName: "", relativePath: ""))
}
