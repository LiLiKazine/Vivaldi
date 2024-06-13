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
//    func change<Value>(keypath: WritableKeyPath<Photo, Value>, value: Value, of id: PersistentIdentifier) async throws
}

@ModelActor
actor AlbumRepositoryImp: AlbumRepository {
    
    func create(album: Album) async throws {
        modelContext.insert(album)
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
