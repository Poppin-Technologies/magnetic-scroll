//
//  Block.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

/**
 A magnetic scroll block.
 
 ``MagneticScrollView`` displays a vertical stack of blocks.
 */
public struct Block: View, Identifiable {
  
  // MARK: - State
  
  /// The height of this block.
  /// This value is used to calculate where the block is positioned in the scroll view.
  @State var height: CGFloat = .zero
  
  // MARK: - Properties
  
  /// The ID of this block.
  /// The underlying `body` property attaches to this ID.
  public var id: UUID
  /// The content to display.
  /// This is a type-erased view.
  var content: AnyView
  
  // MARK: - Views
  
  public var body: some View {
    VStack {
      content
        .readSize { size in
          guard height.isZero else { return }
          self.height = size.height
        }
    }
    .frame(maxWidth: .infinity, maxHeight: height)
    .id(id)
  }
  
  // MARK: - Initalizers
  
  public init(height: CGFloat = .zero, @ViewBuilder body: () -> some View) {
    let body = body()
    self.content = AnyView(body)
    self.id = UUID()
    self.height = height
  }
}
