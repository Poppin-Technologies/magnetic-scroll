//
//  SizePreferenceKey.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
