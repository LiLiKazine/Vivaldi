//
//  Archiver.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/19.
//

import Foundation


class Archiver {
    
    static let shared = Archiver()
    
    func store(_ data: Data, name: String, suffix: String? = nil, directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> String {
        
        let baseDir = try directory.prefferredDirectory()
        
        let path = savingPath(of: name, suffix: suffix, relativeTo: baseDir)
        
        let url = baseDir.appending(path: path)
    
        try store(data, to: url)
        
        return path
    }
    
    func store(_ data: Data, to url: URL) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url, options: .withoutOverwriting)
    }
    
    func fetch(from relativePath: String, directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> Data {
        var url = try directory.prefferredDirectory()
        url.append(path: relativePath)
        return try Data(contentsOf: url)
    }
    
    func savingURL(of path: String, relativeTo directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> URL {
        var url = try directory.prefferredDirectory()
        url.append(path: path)
        return url
    }
    
    func savingPath(of filename: String, suffix: String?, relativeTo dir: URL) -> String {
        let filename = filename.replacingOccurrences(of: "/", with: "-")
        let intermediaDirectory = Date().text()
        var appendix: Int = 0
        var url = dir.appending(path: intermediaDirectory)
        repeat {
            defer { appendix += 1 }
            if appendix > 0 {
                url.deleteLastPathComponent()
                url.append(path: "\(filename)-\(appendix)")
            } else {
                url.append(path: filename)
            }
            if let suffix, suffix.count > 0 {
                url.appendPathExtension(suffix)
            }
        } while FileManager.default.fileExists(atPath: url.path)
        
        let components = url.pathComponents
        
        return components[(components.count - 2)...].joined(separator: "/")
    }
    
}

private extension FileManager.SearchPathDirectory {
    func prefferredDirectory() throws -> URL {
        return try FileManager.default.url(for: self, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}

