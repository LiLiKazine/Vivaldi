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
    
    func onPick(items: [LoadableTranferable], in album: Album?)
    func delete(photo: Photo)
    func change<Value>(keypath: ReferenceWritableKeyPath<Photo, Value>, value: Value, of photo: Photo)
    
    func create(albumWithName name: String)
    func delete(album: Album)
}

final class PhotoInteractorImp : PhotoInteractor {
    
    let photoRepo: PhotoRepository
    let albumRepo: AlbumRepository
    
    init(photoRepo: PhotoRepository, albumRepo: AlbumRepository) {
        self.photoRepo = photoRepo
        self.albumRepo = albumRepo
    }
    
    func onPick(items: [LoadableTranferable], in album: Album?) {
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
                try await photoRepo.insert(photos: photos, in: album)
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
    
    func change<Value>(keypath: ReferenceWritableKeyPath<Photo, Value>, value: Value, of photo: Photo) {
        photo[keyPath: keypath] = value
    }
    
    func create(albumWithName name: String) {
        Task {
            let album = Album(name: name)
            do {
                try await albumRepo.create(album: album)
            } catch {
                print("Create album with name: \(name) failed, error: \(error)")
            }
        }
    }
    
    func delete(album: Album) {
        Task {
            try await albumRepo.delete(albumById: album.id)
        }
    }
}
