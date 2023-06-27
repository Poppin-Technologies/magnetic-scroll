//
//  BlockTupleView.swift
//  tes1y123
//
//  Created by Demirhan Mehmet Atabey on 27.06.2023.
//

import Foundation

/// A block that contains nested `Block`s
public struct BlockTupleView: Block {
    public var id: AnyHashable?
    public var blocks: [Block]
}
