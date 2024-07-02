//
//  Thumbnail.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import SwiftUI
import ImageKit
import ArchiverKit
import AVKit

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
    
    @IKVideo.ControlAction var control
    
    let video: Video
    @Environment(UIConfiguration.self) private var uiConfiguration
    @IKVideo.ControlAction private var action
        
    var body: some View {
        Group {
            switch source(from: video) {
            case .success(let source):
                IKVideo(localVideo: source, controlVisiblity: .alwaysHide)
                    .control($action)
            case .failure(let error):
                Text("Error: \(error.localizedDescription)")
            }
        }
        .frame(
            width: uiConfiguration.photoFrameSize.width,
            height: uiConfiguration.photoFrameSize.height
        )
    }
    
    private func source(from video: Video) -> Result<LocalVideo, Error> {
        do {
            let source = try VideoSource(video: video)
            return .success(source)
        } catch {
            return .failure(error)
        }
    }
}

private struct VideoSource: LocalVideo {
    
    var cover: UIImage? {
        guard let coverRelativePath,
              let url = try? Archiver.shared.savingURL(of: coverRelativePath) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path(percentEncoded: false))
    }
    
    let url: URL
    let coverRelativePath: String?
    
    var duration: CMTime?
    
    init(video: Video) throws {
        url = try Archiver.shared.savingURL(of: video.relativePath)
        coverRelativePath = video.coverRelativePath
        duration = .init(seconds: video.duration, preferredTimescale: 1)
    }
}
