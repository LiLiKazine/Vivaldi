//
//  Photo+AsyncDataSource.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/2.
//

import Foundation
import ImageKit

extension Photo {
    
    func retriver() -> DataRetriver {
        return LocalDataRetriver(relativePath: relativePath)
    }
    
}
