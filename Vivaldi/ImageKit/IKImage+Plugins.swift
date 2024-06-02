//
//  IKImage+Plugins.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import Foundation

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
