//
//  Block.swift
//  tes1y123
//
//  Created by Demirhan Mehmet Atabey on 27.06.2023.
//

import Foundation

public protocol Block {
  var id: AnyHashable? { get set }
}

extension Block {
  // Additional Properties will go here
}

@resultBuilder
struct BlockBuilder {
  public static func buildOptional(_ component: BlockTupleView?) -> BlockTupleView {
      if let component {
          return BlockTupleView(blocks: [component])
      } else {
          return BlockTupleView(blocks: [])
      }
  }

  public static func buildBlock(_ parts: Block...) -> BlockTupleView {
      return BlockTupleView(blocks: parts)
  }

  public static func buildEither(first component: Block) -> BlockTupleView {
      return BlockTupleView(blocks: [component])
  }

  public static func buildEither(second component: Block) -> BlockTupleView {
      return BlockTupleView(blocks: [component])
  }

  public static func buildArray(_ components: [Block]) -> BlockTupleView {
      return BlockTupleView(blocks: components)
  }
}
