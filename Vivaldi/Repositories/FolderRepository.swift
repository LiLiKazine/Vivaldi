//
//  AlbumRepository.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/13.
//

import Foundation
import SwiftData

protocol FolderRepository {
    func create(folder: Folder) async throws
    func delete(folderById id: PersistentIdentifier) async throws
}

@ModelActor
actor FolderRepositoryImp: FolderRepository {
    
    func create(folder: Folder) async throws {
        modelContext.insert(folder)
    }
    
    func delete(folderById id: PersistentIdentifier) async throws {
        guard let album = self[id, as: Folder.self] else {
            //TODO: throw error
            return
        }
        modelContext.delete(album)
    }
 
}
