//
//  ContentView.swift
//  MagneticScrollExample
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI
import MagneticScroll

struct ContentView: View {
  var body: some View {
    VStack {
      MagneticScrollView {
        Block {
          Text("Auto-fit height view")
            .border(.red)
        }
        Block(height: 100.0) {
          Text("Set height view")
            .border(.green)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
