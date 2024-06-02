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
//                        IKImage(source: photo.create())
//                            .resizable()
                        Thumbnail(photo: photo)
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

#Preview {
    ShowcaseView(photos: [])
}
