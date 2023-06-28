//
//  MagneticScrollView.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

@available(iOS 14.0, *)
public struct MagneticScrollView: View {
  
  /// The blocks to display.
  @BlocksBuilder public var tuple: BlocksTupleView
  
  // MARK: - Views
  
  public var body: some View {
    GeometryReader { proxy in
      ScrollView {
        // TODO: Implement block display
        VStack {
          ForEach(tuple.blocks, id: \.id) { block in
            BlockWrapperView(magneticBlock: block)
          }
        }
      }
    }
  }
  
  // MARK: - Initalizers
  
  public init(@BlocksBuilder blocks: () -> BlocksTupleView) {
    self.tuple = blocks()
  }
}

public struct BlocksTupleView: MagneticBlock {
    public var id: AnyHashable?
    public var blocks: [MagneticBlock]
}

@available(iOS 14.0, *)
struct BlockWrapperView: View {
  var magneticBlock: MagneticBlock
  
  var body: some View {
    Group {
      switch magneticBlock {
      case let block as Block:
        BlockView(block: block) {
          Text("Hello World")
        }
      default:
        EmptyView()
      }
    }
  }
}
