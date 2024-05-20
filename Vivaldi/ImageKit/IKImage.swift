//
//  IKImage.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI

struct IKImage: View {
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    IKImage()
}


protocol AsyncImageDataSource {
    func retrive() async throws -> Data
}

protocol RetrivedDataProcessor {
    func process(_ data: Data) async throws -> Data
}

protocol ThumbnailGenerator {
    func generate(from data: Data) async throws -> Data
}

protocol ImageMemoryCache {
    
    var totalCostLimit: Int { get }
    var countLimit: Int { get }
    
    var onCacheExpire: (Data, String) -> Void { get set }
    
    func cache(original data: String, key: String)
    
    func cache(thumbnail data: String, key: String)
    
}


