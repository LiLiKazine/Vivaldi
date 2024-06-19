//
//  PhotoRepository.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/5.
//

import Foundation
import SwiftData

protocol PhotoRepository {
    func insert(documents: [Document], in album: Folder?) async throws
    func delete(documentById id: PersistentIdentifier) async throws
}

@ModelActor
actor PhotoRepositoryImp: PhotoRepository {
    
    func insert(documents: [Document], in album: Folder?) async throws {
        documents.forEach { modelContext.insert($0) }
        if let album, let contextAlbum = self[album.id, as: Folder.self] {
            documents.forEach { $0.folders.append(contextAlbum) }
        }
        //FIXME: update ui
    }
    
    func delete(documentById id: PersistentIdentifier) async throws {
        guard let document = self[id, as: Document.self] else {
            //TODO: throw error
            return
        }
        modelContext.delete(document)
    }
    
}
