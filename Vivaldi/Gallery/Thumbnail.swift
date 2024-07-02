//
//  Thumbnail.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import SwiftUI
import ImageKit
import ArchiverKit

protocol ThumbnailRenderer {
    associatedtype Content: View
    func render() -> Content
}

struct Thumbnail: View {
    
    private let document: Document
    
    init(document: Document) {
        self.document = document
    }
    
    var body: some View {
        switch document.media {
        case .photo(let photo):
            photo.render()
        case .video(let video):
            video.render()
        }
    }
}

extension Photo: ThumbnailRenderer {
    func render() -> ImageThumbnail {
        ImageThumbnail(photo: self)
    }
}

struct ImageThumbnail: View {
    
    @Environment(UIConfiguration.self) private var uiConfiguration
    let photo: Photo
    
    var body: some View {
        Color.white
            .frame(
                width: uiConfiguration.photoFrameSize.width,
                height: uiConfiguration.photoFrameSize.height
            )
            .overlay {
                IKImage(retriver: photo.retriver())
                    .backup(retriver: photo.backupRetriver())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .clipped()
    }
}

extension Video: ThumbnailRenderer {
    func render() -> VideoPreview {
        VideoPreview(video: self)
    }
}

struct VideoPreview: View {
    
    let video: Video
    
    var body: some View {
        switch url(from: video) {
        case .success(let url):
            IKVideo(url: url)
        case .failure(let error):
            Text("Error: \(error.localizedDescription)")
        }
    }
    
    private func url(from video: Video) -> Result<URL, Error> {
        do {
            let url = try Archiver.shared.savingURL(of: video.relativePath)
            return .success(url)
        } catch {
            return .failure(error)
        }
    }
}
