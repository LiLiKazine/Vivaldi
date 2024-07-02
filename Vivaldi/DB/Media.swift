//
//  Media.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/19.
//

import Foundation
enum Media: Codable {
    case photo(Photo)
    case video(Video)
}


//MARK: Edit
extension Media {
    
    var relativePath: String {
        get {
            switch self {
            case .photo(let photo): return photo.relativePath
            case .video(let video): return video.relativePath
            }
        }
        set {
            switch self {
            case .photo(var photo):
                photo.relativePath = newValue
                self = .photo(photo)
            case .video(var video):
                video.relativePath = newValue
                self = .video(video)
            }
        }
    }
    
    var photo: Photo? {
        guard case .photo(let photo) = self else {
            return nil
        }
        return photo
    }
    
    var video: Video? {
        guard case .video(let video) = self else {
            return nil
        }
        return video
    }
    
    @discardableResult
    mutating func update<Value>(value: Value, of keyPath: WritableKeyPath<Video, Value>) -> Bool {
        switch self {
        case .video(var video):
            video[keyPath: keyPath] = value
            self = .video(video)
            return true
        default:
            return false
        }
    }
    
    @discardableResult
    mutating func update<Value>(value: Value, of keyPath: WritableKeyPath<Photo, Value>) -> Bool {
        switch self {
        case .photo(var photo):
            photo[keyPath: keyPath] = value
            self = .photo(photo)
            return true
        default:
            return false
        }
    }
}
