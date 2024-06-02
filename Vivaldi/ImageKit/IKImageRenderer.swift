//
//  IKImageRenderer.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/21.
//

import SwiftUI

struct IKImageRenderer: View {
    
    let context: IKImage.Context
    
    @State private var binder =  IKImageBinderImp()
    
    var body: some View {
        if let image = binder.image {
            renderedImage(image)
        } else {
            Text("loading...")
                .task {
                    do {
                        try await binder.load(with: context)
                    } catch {
                        print(error)
                    }
                }
        }
    }
    
    @ViewBuilder
    private func renderedImage(_ image: UIImage) -> some View {
        let configuredImage = context.configurations
            .reduce(Image.created(from: image)) {
                current, config in config(current)
            }
        
        configuredImage
    }
}

extension Image {
    public static func created(from image: UIImage) -> Image {
        Image(uiImage: image)
    }
}

#Preview {
    IKImageRenderer(context: IKImage.Context(source: .systemImage("")))
}
