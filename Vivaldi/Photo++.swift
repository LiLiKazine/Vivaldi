//
//  Photo+AsyncDataSource.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import Foundation
import ImageKit
import ArchiverKit

extension Photo {
    
    func retriver() -> DataRetriver {
        return LocalDataRetriver(relativePath: relativePath)
    }
    
    func savingURL() throws -> URL {
        return try Archiver.shared.savingURL(of: relativePath)
    }
    
}

extension Array where Element == Photo {
    
    func previewURLs() -> [URL] {
        do {
            return try map { try $0.savingURL() }
        } catch {
            print(error)
            return []
        }
    }
    
}
