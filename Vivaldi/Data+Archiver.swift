//
//  Data+Archiver.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import Foundation

extension Data {
    
    func store(_ data: Data, name: String, suffix: String? = nil, directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> String {
        return try Archiver.shared.store(data, name: name, suffix: suffix, directory: directory)
    }
    
}
