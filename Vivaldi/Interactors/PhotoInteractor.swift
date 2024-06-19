//
//  PhotoInteractor.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/6.
//

import SwiftUI

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
    
    func onPick(items: [LoadableTranferable], in album: Album?, thumbnailHeight: CGFloat?)
    func delete(document: Document)
    func change<Value>(keypath: ReferenceWritableKeyPath<Document, Value>, value: Value, of document: Document)
    
    func create(albumWithName name: String)
    func delete(album: Album)
    func change<Value>(keypath: ReferenceWritableKeyPath<Album, Value>, value: Value, of album: Album)
}
