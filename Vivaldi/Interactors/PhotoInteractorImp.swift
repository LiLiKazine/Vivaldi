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
                let photos = try await items.asyncCompactMap { item -> Document? in
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
                    let photo = Document(photoName: name, relativePath: relativePath)
                    do {
                        if let thumbnailHeight,
                           let thumbnail = data.ik.jpeg(ratio: .fixedHeight(thumbnailHeight), quality: 0.5) {
                            let thumbRelativePath = try thumbnail.ak.store(using: "\(name)_thumb", suffix: "jpeg")
                            photo.media.update(value: thumbRelativePath, of: \.thumbRelativePath)
                        }
                    } catch {
                        print("Store thumnail failed, reason: \(error)")
                    }
                    return photo
                }
                try await photoRepo.insert(documents: photos, in: album)
            } catch {
                print("Insert failed: \(error)")
            }
        }
    }
    
    func delete(document: Document) {
        Task {
            do {
                try await photoRepo.delete(documentById: document.id)
                try Archiver.shared.delete(at: document.relativePath)
                if let thumbRelativePath = document.thumbRelativePath {
                    try Archiver.shared.delete(at: thumbRelativePath)
                }
            } catch {
                print("Delete failed: \(error)")
            }
        }
    }
    
    func change<Value>(keypath: ReferenceWritableKeyPath<Document, Value>, value: Value, of document: Document) {
        document[keyPath: keypath] = value
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
