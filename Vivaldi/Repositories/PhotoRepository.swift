//
//  PhotoRepository.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/5.
//

import Foundation
import SwiftData

protocol PhotoRepository {
    func insert(documents: [Document], in album: Album?) async throws
    func delete(documentById id: PersistentIdentifier) async throws
}

@ModelActor
actor PhotoRepositoryImp: PhotoRepository {
    
    func insert(documents: [Document], in album: Album?) async throws {
        documents.forEach { modelContext.insert($0) }
        if let album, let contextAlbum = self[album.id, as: Album.self] {
            documents.forEach { $0.albums.append(contextAlbum) }
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
