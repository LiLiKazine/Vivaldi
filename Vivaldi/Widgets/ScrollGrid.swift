//
//  ScrollGrid.swift
//  Vivaldi
//
//  Created by LiLi on 2024/6/4.
//

import SwiftUI

struct ScrollVGrid<Content> : View where Content : View {
    
    private let columns: [GridItem]
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: () -> Content
    
    public init(columns: [GridItem], alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews, content: content)
        }
    }
}
