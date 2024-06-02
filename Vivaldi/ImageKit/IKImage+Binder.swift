//
//  IKImage+Binder.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/21.
//

import Foundation
import UIKit

protocol IKImageBinder {
    
    var image: UIImage? { get }
    
    func load(with context: IKImage.Context) async throws
    
}

@Observable
class IKImageBinderImp: IKImageBinder {
    var image: UIImage?
    
    func load(with context: IKImage.Context) async throws {
        switch context.source {
        case .systemImage(let systemName):
            self.image = .init(systemName: systemName)
        case .async(let dataSource):
            let data = try await dataSource.retrive()
            self.image = UIImage(data: data)
        }
    }
    
}

