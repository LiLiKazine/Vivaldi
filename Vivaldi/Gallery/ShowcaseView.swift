//
//  ShowcaseView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI

private let COLUMNS = [GridItem(), GridItem(), GridItem()]

struct ShowcaseView: View {
    
    let photos: [Photo]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(
                columns: COLUMNS,
                alignment: .center
            ) {
                ForEach(photos) { photo in
                    VStack {
                        IKImage(source: .async(LocalImageDataSource(relativePath: photo.relativePath)))
                            .resizable()
                            .frame(height: 100)
                            
                        Text(photo.name)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
            }
        }
        .padding()
    }
}

class LocalImageDataSource: AsyncImageDataSource {
    
    var cacheKey: String? { relativePath }
    
    private let relativePath: String
    
    init(relativePath: String) {
        self.relativePath = relativePath
    }
    
    func retrive() async throws -> Data {
        try Data(from: relativePath)
    }
    
    
}

#Preview {
    ShowcaseView(photos: [])
}
