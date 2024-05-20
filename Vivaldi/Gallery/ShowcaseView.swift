//
//  ShowcaseView.swift
//  Vivaldi
//
//  Created by LiLi on 2024/5/20.
//

import SwiftUI

private let COLUMNS = [GridItem(.fixed(3))]

struct ShowcaseView: View {
    
    let photos: [Photo]
    
    
    var body: some View {
        LazyVGrid(
            columns: COLUMNS,
            alignment: .center
            ) {
            
        }
    }
}

#Preview {
    ShowcaseView(photos: [])
}
