//
//  AlbumItemInserter.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers.UTType
import SwiftData

protocol ContentReadable {
    var itemIdentifier: String? { get }
    var supportedContentTypes: [UTType] { get }
}

protocol TransferableLoadable {
    func load<T>(type: T.Type) async throws -> T? where T : Transferable
}

protocol AlbumItemInserter {
    func insert(loadable items: [TransferableLoadable & ContentReadable]) async throws
}


class AlbumItemInserterImp: AlbumItemInserter {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func insert(loadable items: [ContentReadable & TransferableLoadable]) async throws {
        for item in items {
            guard let preferredType = item.supportedContentTypes.first else {
                //TODO: throw error
                continue
            }
            let name = item.itemIdentifier ?? "No name"
            guard let data = try await item.load(type: Data.self) else {
                //TODO: throw error
                continue
            }
            let relativePath = try data.store(data, name: name, suffix: preferredType.preferredFilenameExtension)
            let photo = Photo(name: name, relativePath: relativePath)
            modelContext.insert(photo)
        }
    }
    
}
