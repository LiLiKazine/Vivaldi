//
//  Photo+AsyncDataSource.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import Foundation

extension Photo {
    
    func create() -> IKImage.Source {
        return .async(LocalImageDataSource(relativePath: relativePath))
    }
    
}
