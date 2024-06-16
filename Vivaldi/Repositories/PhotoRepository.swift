//
//  PhotoRepository.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/5.
//

import Foundation
import SwiftData

protocol PhotoRepository {
    func insert(photos: [Photo], in album: Album?) async throws
    func delete(photoById id: PersistentIdentifier) async throws
    
//    func change<Value>(keypath: WritableKeyPath<Photo, Value>, value: Value, of id: PersistentIdentifier) async throws
}

@ModelActor
actor PhotoRepositoryImp: PhotoRepository {
    
    func insert(photos: [Photo], in album: Album?) async throws {
        photos.forEach { modelContext.insert($0) }
        if let album, let contextAlbum = self[album.id, as: Album.self] {
            photos.forEach { $0.albums.append(contextAlbum) }
        }
        //FIXME: update ui
    }
    
    func delete(photoById id: PersistentIdentifier) async throws {
        guard let photo = self[id, as: Photo.self] else {
            //TODO: throw error
            return
        }
        modelContext.delete(photo)
    }
    
    /*
    func change<Value>(keypath: WritableKeyPath<Photo, Value>, value: Value, of id: PersistentIdentifier) async throws {
        //TODO: update ui on changes
//        guard var photo = self[id, as: Photo.self] else {
//            //TODO: throw error
//            return
//        }
//        photo[keyPath: keypath] = value
        let context = await modelContainer.mainContext
        guard var photo = context.model(for: id) as? Photo else {
            return
        }
        photo[keyPath: keypath] = value
    }
     */
 
}
