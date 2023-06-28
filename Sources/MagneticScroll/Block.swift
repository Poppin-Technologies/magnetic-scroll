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
public struct BlockView: View, MagneticBlock {
  // MARK: - State
  
  /// The height of this block.
  /// This value is used to calculate where the block is positioned in the scroll view.
  @State private var height: CGFloat
  // MARK: - Properties
  
  /// The ID of this block.
  /// The underlying `body` property attaches to this ID.
  public var id: AnyHashable?
  
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
    .frame(maxWidth: .infinity)
    .frame(height: height)
    .id(id)
  }
  
  // MARK: - Initalizers
  
  public init(block: Block, @ViewBuilder body: () -> some View) {
    let body = body()
    self.content = AnyView(body)
    self.id = UUID()
    self.height = block.height
  }
}


public struct Block: MagneticBlock {
  public var id: AnyHashable?
  public var height: CGFloat
  public var spacing: CGFloat = 20
}
