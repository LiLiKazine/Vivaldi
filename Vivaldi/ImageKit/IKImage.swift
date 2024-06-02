//
//  IKImage.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI

struct IKImage: View {
    
    let context: Context
    
    init(context: Context) {
        self.context = context
    }
    
    init(source: Source) {
        self.init(context: Context(source: source))
    }
    
    var body: some View {
        ZStack {
            IKImageRenderer(context: context)
        }
    }
}

extension IKImage {
    public func resizable(
        capInsets: EdgeInsets = EdgeInsets(),
        resizingMode: Image.ResizingMode = .stretch) -> IKImage
    {
        configure { $0.resizable(capInsets: capInsets, resizingMode: resizingMode) }
    }

    public func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> IKImage {
        configure { $0.renderingMode(renderingMode) }
    }

    public func interpolation(_ interpolation: Image.Interpolation) -> IKImage {
        configure { $0.interpolation(interpolation) }
    }

    public func antialiased(_ isAntialiased: Bool) -> IKImage {
        configure { $0.antialiased(isAntialiased) }
    }
    
    public func configure(_ block: @escaping (Image) -> Image) -> Self {
        context.configurations.append(block)
        return self
    }
}

extension IKImage {
    
    func thumbnailGenerator(_ generator: ThumbnailGenerator) -> IKImage {
        context.options.thumbnailGenerator = generator
        return self
    }
    
    func memoryCache(_ cache: ImageMemoryCache) -> IKImage {
        context.options.memoryCache = cache
        return self
    }
    
    func diskCache(_ cache: ImageDiskCache) -> IKImage {
        context.options.diskCache = cache
        return self
    }
    
    private func append(_ configuration: @escaping (Image) -> Image) -> IKImage {
        context.configurations.append(configuration)
        return self
    }
    
}

extension IKImage {
    enum Source {
        case systemImage(String)
        case async(AsyncImageDataSource)
    }
    
    class Context {
        
        let source: Source
       
        var options: Options
        
        var configurations: [(Image) -> Image]
        
        init(source: Source,
             options: Options = .init(),
             configurations: [(Image) -> Image] = []) {
            self.source = source
            self.options = options
            self.configurations = configurations
        }
    }
    
    struct Options {
        var thumbnailGenerator: ThumbnailGenerator?
        var memoryCache: ImageMemoryCache?
        var diskCache: ImageDiskCache?
    }
}

#Preview {
    IKImage(source: .systemImage("doc.text.image"))
}


protocol AsyncImageDataSource {
    var cacheKey: String? { get }
    func retrive() async throws -> Data
}

protocol ThumbnailGenerator {
    func generate(from data: Data) async throws -> Data
}

protocol ImageMemoryCache {
    
//    var onCacheExpire: (Data, String) -> Void { get set }
    
    func cache(image data: String, key: String)
    
    func cache(thumbnail data: String, key: String)
    
    func image(for key: String) -> Data?
    
    func thumbnail(for key: String) -> Data?
    
}

protocol ImageDiskCache {
    
    func cache(original data: String, key: String)
    
    func cache(thumbnail data: String, key: String)
    
}


