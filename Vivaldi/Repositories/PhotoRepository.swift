//
//  PhotoRepository.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/5.
//

import Foundation
import SwiftData

protocol PhotoRepository {
    func insert(loadable items: [LoadableTranferable]) async throws
}

@ModelActor
actor PhotoRepositoryImp: PhotoRepository {
    
    func insert(loadable items: [LoadableTranferable]) async throws {
        for item in items {
            guard let preferredType = item.supportedContentTypes.first else {
                //TODO: throw error
                continue
            }
            guard let data = try await item.load(type: Data.self) else {
                //TODO: throw error
                continue
            }
            let name = item.itemIdentifier ?? "untitled"
            let relativePath = try data.ak.store(using: name, suffix: preferredType.preferredFilenameExtension)
            let photo = Photo(name: name, relativePath: relativePath)
            modelContext.insert(photo)
        }
    }
    
}
