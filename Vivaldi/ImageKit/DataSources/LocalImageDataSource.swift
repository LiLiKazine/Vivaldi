//
//  LocalImageDataSource.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import Foundation


class LocalImageDataSource: AsyncImageDataSource {
    
    var cacheKey: String? { relativePath }
    
    private let relativePath: String
    
    init(relativePath: String) {
        self.relativePath = relativePath
    }
    
    func retrive() async throws -> Data {
        try Data(from: relativePath)
    }
    
    
}
