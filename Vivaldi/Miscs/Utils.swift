//
//  Utils.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/6.
//

import Foundation

func address(of object: AnyObject) -> UnsafeMutableRawPointer {
    let address = Unmanaged.passUnretained(object).toOpaque()
    return address
}

extension Sequence {
    func asyncMap<T>(
            _ transform: (Element) async throws -> T
        ) async rethrows -> [T] {
            var values = [T]()

            for element in self {
                try await values.append(transform(element))
            }

            return values
        }
    
    func asyncCompactMap<T>(
            _ transform: (Element) async throws -> T?
        ) async rethrows -> [T] {
            var values = [T]()

            for element in self {
                guard let value = try await transform(element) else {
                    continue
                }
                values.append(value)
            }

            return values
        }
}
