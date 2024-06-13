//
//  LocalContainer.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/6. 
//

import Foundation
import SwiftData

class LocalContainer {
    
    static let sharedPhotoContainer : ModelContainer = {
        let schema = Schema([Photo.self])
        let config = ModelConfiguration(schema: schema)
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            print("container setup failed: \(error.localizedDescription) \(error)")
            fatalError(error.localizedDescription)
        }
    }()
    
    static let sharedAlbumContainer : ModelContainer = {
        let schema = Schema([Album.self])
        let config = ModelConfiguration(schema: schema)
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            print("container setup failed: \(error.localizedDescription) \(error)")
            fatalError(error.localizedDescription)
        }
    }()
    
    static let sharedPhotoRepo : PhotoRepository = {
        return PhotoRepositoryImp(modelContainer: sharedPhotoContainer)
    }()
    
    static let sharedAlbumRepo : AlbumRepository = {
        return AlbumRepositoryImp(modelContainer: sharedAlbumContainer)
    }()
    
    static let sharedPhotoInteractor : PhotoInteractor = {
        return PhotoInteractorImp(photoRepo: sharedPhotoRepo, albumRepo: sharedAlbumRepo)
    }()
}
