//
//  MagneticScrollView.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

struct MagneticScrollView: View {
  
  var blocks: [Block]
  
  // MARK: - Views
  
  var body: some View {
    GeometryReader { proxy in
      
    }
  }
}

/**
 A magnetic scroll block.
 
 ``MagneticScrollView`` displays a vertical stack of blocks.
 */
struct Block: View {
  
  // MARK: - State
  
  /// The height of this block.
  /// This value is used to calculate where the block is positioned in the scroll view.
  @State var height: CGFloat
  
  // MARK: - Properties
  
  /// The content to display.
  /// This is a type-erased view.
  var content: AnyView
  
  // MARK: - Views
  
  var body: some View {
    VStack {
      content
        .readSize { size in
          guard height.isZero else { return }
          self.height = size.height
        }
    }
    .frame(maxWidth: .infinity, maxHeight: height)
  }
  
  // MARK: - Initalizer
  
  init(height: CGFloat = .zero, @ViewBuilder body: () -> some View) {
    self.height = height
    let body = body()
    self.content = AnyView(body)
  }
}
