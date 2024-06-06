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
    
    @Bindable var photo: Photo
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            Color.white
                .frame(height: 100)
                .overlay {
                    IKImage(retriver: photo.retriver())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .clipped()
            
            EditText(isEditing: $isEditing, text: $photo.name)
            .lineLimit(1)
            .truncationMode(.middle)
            .contentShape(Rectangle())
            .onTapGesture {
                isEditing = true
            }
        }
    }
    
    private func update(_ name: String) {
        
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
