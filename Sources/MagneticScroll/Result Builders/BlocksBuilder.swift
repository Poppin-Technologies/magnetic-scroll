//
//  BlocksBuilder.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

@resultBuilder
public struct BlocksBuilder {
  
  public static func buildBlock(_ parts: Block...) -> [Block] {
    return parts
  }
  
  static func buildEither(first component: Block) -> [Block] {
    return [component]
  }
  
  static func buildEither(second component: Block) -> [Block] {
    return [component]
  }
  
  static func buildArray(_ components: [Block]) -> [Block] {
    return components
  }
}
