//
//  PhotoRepository.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/5.
//

import Foundation
import SwiftData

protocol PhotoRepository {
    func insert(photos: [Photo]) async throws
    func delete(photoById id: PersistentIdentifier) async throws
    func change<Value>(keypath: WritableKeyPath<Photo, Value>, value: Value, of id: PersistentIdentifier) async throws
}

@ModelActor
actor PhotoRepositoryImp: PhotoRepository {
    
    func insert(photos: [Photo]) async throws {
        photos.forEach { modelContext.insert($0) }
    }
    
    func delete(photoById id: PersistentIdentifier) async throws {
        guard let photo = self[id, as: Photo.self] else {
            //TODO: throw error
            return
        }
        modelContext.delete(photo)
    }
    
    func change<Value>(keypath: WritableKeyPath<Photo, Value>, value: Value, of id: PersistentIdentifier) async throws {
        //TODO: update ui on changes
        guard var photo = self[id, as: Photo.self] else {
            //TODO: throw error
            return
        }
        photo[keyPath: keypath] = value
    }
 
}
