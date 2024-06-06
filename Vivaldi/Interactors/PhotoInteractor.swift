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
    
    func onPick(items: [LoadableTranferable])
    
}

final class PhotoInteractorImp : PhotoInteractor {
    
    let photoRepo: PhotoRepository
    
    init(photoRepo: PhotoRepository) {
        self.photoRepo = photoRepo
    }
    
    func onPick(items: [LoadableTranferable]) {
        Task {
            do {
                try await photoRepo.insert(loadable: items)
            } catch {
                print("Insert failed: \(error)")
            }
        }
    }
}

final class MockPhotoInteractor: PhotoInteractor {
    func onPick(items: [LoadableTranferable]) {
    }
}
