//
//  AlbumRepository.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/13.
//

import Foundation
import SwiftData

protocol AlbumRepository {
    func create(album: Album) async throws
    func delete(albumById id: PersistentIdentifier) async throws
}

@ModelActor
actor AlbumRepositoryImp: AlbumRepository {
    
    func create(album: Album) async throws {
        modelContext.insert(album)
    }
    
    func delete(albumById id: PersistentIdentifier) async throws {
        guard let album = self[id, as: Album.self] else {
            //TODO: throw error
            return
        }
        modelContext.delete(album)
    }
 
}
