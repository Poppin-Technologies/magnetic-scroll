//
//  BlockStack.swift
//  tes1y123
//
//  Created by Demirhan Mehmet Atabey on 27.06.2023.
//

import SwiftUI

/// A `Block` that stacks the `blocks`
@available(iOS 14, *)
public struct BlockStack: View, Block {
  public var id: AnyHashable?
  @BlockBuilder var blocks: BlockTupleView
  
  public var body: some View {
    VStack {
      
    }
  }
}
