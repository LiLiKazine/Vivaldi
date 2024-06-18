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
        if let thumbRelativePath {
            return LocalDataRetriver(relativePath: thumbRelativePath)
        }
        return LocalDataRetriver(relativePath: relativePath)
    }
    
    func backupRetriver() -> DataRetriver? {
        if thumbRelativePath == nil { return nil }
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
    
    mutating func update<Value>(keypath: WritableKeyPath<Element, Value>, to value: Value, where condition: (Element) -> Bool) {
        for (i, element) in self.enumerated() {
            guard condition(element) else { continue }
            self[i][keyPath: keypath] = value
        }
    }
    
}
