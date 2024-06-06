//
//  LoadableTranferable.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/6.
//

import Foundation
import UniformTypeIdentifiers.UTType
import CoreTransferable


protocol LoadableTranferable {
    
    var itemIdentifier: String? { get }
    var supportedContentTypes: [UTType] { get }
    
    func load<T>(type: T.Type) async throws -> T? where T : Transferable
}
