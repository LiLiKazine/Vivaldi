//
//  LocalContainer.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/6. 
//

import Foundation
import SwiftData

class LocalContainer {
    
    static let sharedContainer : ModelContainer = {
        do {
            return try ModelContainer(
                for: Document.self, Folder.self,
                configurations: ModelConfiguration(), ModelConfiguration()
            )
        } catch {
            print("container setup failed: \(error.localizedDescription) \(error)")
            fatalError(error.localizedDescription)
        }
    }()
    
    static let sharedPhotoRepo : PhotoRepository = {
        return PhotoRepositoryImp(modelContainer: sharedContainer)
    }()
    
    static let sharedFolderRepo : FolderRepository = {
        return FolderRepositoryImp(modelContainer: sharedContainer)
    }()
    
    static let sharedPhotoInteractor : PhotoInteractor = {
        return PhotoInteractorImp(photoRepo: sharedPhotoRepo, albumRepo: sharedFolderRepo)
    }()
}
