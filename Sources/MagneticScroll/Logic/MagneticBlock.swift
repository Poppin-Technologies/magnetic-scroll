//
//  MagneticBlock.swift
//  
//
//  Created by Demirhan Mehmet Atabey on 29.06.2023.
//

import SwiftUI

@available(iOS 14.0, *)
internal struct MagneticBlock: Identifiable {
  var id: String = ""
  var height: CGFloat
}

@available(iOS 14.0, *)
extension MagneticBlock: Equatable {
  static func == (lhs: MagneticBlock, rhs: MagneticBlock) -> Bool {
    lhs.id == rhs.id
  }
}

@available(iOS 14.0, *)
extension MagneticBlock: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension MagneticBlock {
  static var EmptyBlock: MagneticBlock {
    return .init(height: 0)
  }
}
