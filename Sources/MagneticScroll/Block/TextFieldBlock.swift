//
//  TextFieldBlock.swift
//  tes1y123
//
//  Created by Demirhan Mehmet Atabey on 27.06.2023.
//

import SwiftUI

@available(iOS 14, *)
public struct TextFieldBlock: View, Block {
  public var id: AnyHashable?
  @Binding var text: String
  
  public var body: some View {
    TextField("", text: $text)
  }
}
