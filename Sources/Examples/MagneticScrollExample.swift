//
//  File.swift
//  
//
//  Created by Demirhan Mehmet Atabey on 27.06.2023.
//

import SwiftUI
import MagneticScroll

struct MagneticScrollExample: View {
  var body: some View {
    BlockStack {
        FormBlock {
          TextFieldBlock(text: $text)
        }
      
        FormBlock {
          TextFieldBlock(text: $text)
        }
    }
  }
}
