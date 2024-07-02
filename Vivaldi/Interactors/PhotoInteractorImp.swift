//
//  PhotoInteractorImp.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/18.
//

import UIKit
import SwiftData
import ImageKit
import ArchiverKit


final class PhotoInteractorImp : PhotoInteractor {
    
    let photoRepo: PhotoRepository
    let albumRepo: FolderRepository
    
    init(photoRepo: PhotoRepository, albumRepo: FolderRepository) {
        self.photoRepo = photoRepo
        self.albumRepo = albumRepo
    }
    
    func onPick(items: [LoadableTranferable], in folder: Folder?, thumbnailHeight: CGFloat?) {
        Task {
            do {
                let documents = try await items.asyncCompactMap { item -> Document? in
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
                    if preferredType.conforms(to: .image) {
                        return photo(data, name: name, relativePath: relativePath, folder: folder, thumbnailHeight: thumbnailHeight)
                    }
                    else if preferredType.conforms(to: .movie) {
                        return await video(data, name: name, relativePath: relativePath, folder: folder, thumbnailHeight: thumbnailHeight)
                    }
                    else {
                        //TODO: throw error
                    }
                    return nil
                }
                try await photoRepo.insert(documents: documents, in: folder)
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
            let album = Folder(name: name)
            do {
                try await albumRepo.create(folder: album)
            } catch {
                print("Create album with name: \(name) failed, error: \(error)")
            }
        }
    }
    
    func delete(album: Folder) {
        Task {
            try await albumRepo.delete(folderById: album.id)
        }
    }
    
    func change<Value>(keypath: ReferenceWritableKeyPath<Folder, Value>, value: Value, of album: Folder) {
        album[keyPath: keypath] = value
    }
}

private extension PhotoInteractorImp {
    
    func video(_ data: Data, name: String, relativePath: String, folder: Folder?, thumbnailHeight: CGFloat?) async -> Document {
        let video = Document(videoName: name, relativePath: relativePath)
        do {
            if let thumbnailHeight {
                let boundingSize = CGSize(width: .greatestFiniteMagnitude, height: thumbnailHeight)
                let url = try Archiver.shared.savingURL(of: relativePath)
                let cover = try await url.ik.cover(maxiumSize: boundingSize)
                if let data = UIImage(cgImage: cover).jpegData(compressionQuality: 1) {
                   let coverRelativePath = try data.ak.store(using: "\(name)_cover", suffix: "jpeg")
                    video.media.update(value: coverRelativePath, of: \.coverRelativePath)
                } else {
                    print("Generate jpeg data failed.")
                }
            }
        } catch {
            print("Store cover failed, reason: \(error)")
        }
        
        return video
    }
    
    func photo(_ data: Data, name: String, relativePath: String, folder: Folder?, thumbnailHeight: CGFloat?) -> Document {
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
    
}
