//
//  PhotoInteractorImp.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/18.
//

import Foundation
import SwiftData
import ImageKit
import ArchiverKit


final class PhotoInteractorImp : PhotoInteractor {
    
    let photoRepo: PhotoRepository
    let albumRepo: AlbumRepository
    
    init(photoRepo: PhotoRepository, albumRepo: AlbumRepository) {
        self.photoRepo = photoRepo
        self.albumRepo = albumRepo
    }
    
    func onPick(items: [LoadableTranferable], in album: Album?, thumbnailHeight: CGFloat?) {
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
                    let photo = Photo(name: name, relativePath: relativePath)
                    do {
                        if let thumbnailHeight,
                           let thumbnail = data.ik.jpeg(ratio: .fixedHeight(thumbnailHeight), quality: 0.5) {
                            let thumbRelativePath = try thumbnail.ak.store(using: "\(name)_thumb", suffix: "jpeg")
                            photo.thumbRelativePath = thumbRelativePath
                        }
                    } catch {
                        print("Store thumnail failed, reason: \(error)")
                    }
                    return photo
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
                try Archiver.shared.delete(at: photo.relativePath)
                if let thumbRelativePath = photo.thumbRelativePath {
                    try Archiver.shared.delete(at: thumbRelativePath)
                }
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
    
    func change<Value>(keypath: ReferenceWritableKeyPath<Album, Value>, value: Value, of album: Album) {
        album[keyPath: keypath] = value
    }
}
