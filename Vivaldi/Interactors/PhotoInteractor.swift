//
//  PhotoInteractor.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/6.
//

import SwiftUI
import SwiftData

private struct PhotoInteractorEnvironmentKey: EnvironmentKey {
    static var defaultValue: PhotoInteractor?
}

extension EnvironmentValues {
    var photoInteractor: PhotoInteractor? {
      get { self[PhotoInteractorEnvironmentKey.self] }
      set { self[PhotoInteractorEnvironmentKey.self] = newValue }
    }
}

protocol PhotoInteractor {
    
    #if DEBUG
    var photoRepo: PhotoRepository { get }
    #endif
    
    func onPick(items: [LoadableTranferable])
    func delete(photo: Photo)
    func change(name: String, of id: PersistentIdentifier)
}

final class PhotoInteractorImp : PhotoInteractor {
    
    let photoRepo: PhotoRepository
    
    init(photoRepo: PhotoRepository) {
        self.photoRepo = photoRepo
    }
    
    func onPick(items: [LoadableTranferable]) {
        print(items)
        Task {
            do {
                let photos = try await items.asyncCompactMap { item -> Photo? in
                    guard let preferredType = item.supportedContentTypes.first else {
                        //TODO: throw error
                        return nil
                    }
                    guard let data = try await item.load(type: Data.self) else {
                        //TODO: throw error
                        return nil
                    }
                    let name = item.itemIdentifier ?? "untitled"
                    let relativePath = try data.ak.store(using: name, suffix: preferredType.preferredFilenameExtension)
                    return Photo(name: name, relativePath: relativePath)
                }
                try await photoRepo.insert(photos: photos)
            } catch {
                print("Insert failed: \(error)")
            }
        }
    }
    
    func delete(photo: Photo) {
        Task {
            do {
                try await photoRepo.delete(photoById: photo.id)
            } catch {
                print("Delete failed: \(error)")
            }
        }
    }
    
    func change(name: String, of id: PersistentIdentifier) {
        Task {
            do {
                try await photoRepo.change(keypath: \.name, value: name, of: id)
            } catch {
                print("Change failed: \(error)")
            }
        }
    }
}
