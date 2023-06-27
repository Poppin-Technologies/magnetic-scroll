//
//  FormStack.swift
//  tes1y123
//
//  Created by Demirhan Mehmet Atabey on 27.06.2023.
//

import SwiftUI

@available(iOS 14, *)
public struct FormBlock: View, Block {
  public var id: AnyHashable?
  
  @BlockBuilder var blocks: BlockTupleView
    public var body: some View {
    Text("Hello World")
  }
}
