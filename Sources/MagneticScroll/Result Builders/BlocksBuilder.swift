//
//  BlocksBuilder.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

@available(iOS 14.0, *)
@resultBuilder
public struct BlocksBuilder {
  
  public static func buildBlock(_ parts: MagneticBlock...) -> [MagneticBlock] {
    return parts
  }
  
  static func buildEither(first component: MagneticBlock) -> [MagneticBlock] {
    return [component]
  }
  
  static func buildEither(second component: MagneticBlock) -> [MagneticBlock] {
    return [component]
  }
  
  static func buildArray(_ components: [MagneticBlock]) -> [MagneticBlock] {
    return components
  }
}
