//
//  MagneticScrollView.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

public struct MagneticScrollView: View {
  
  /// The blocks to display.
  var blocks: [Block]
  
  // MARK: - Views
  
  public var body: some View {
    GeometryReader { proxy in
      ScrollView {
        // TODO: Implement block display
        VStack {
          ForEach(blocks) { block in
            block
          }
        }
      }
    }
  }
  
  // MARK: - Initalizers
  
  public init(@BlocksBuilder blocks: () -> [Block]) {
    self.blocks = blocks()
  }
}
