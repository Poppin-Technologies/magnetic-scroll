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
      MagneticScrollView(spacing: 12.0) {
        Text("Hello World")
          .frame(maxWidth: .infinity)
          .frame(height: 100.0)
          .background(Color.red)
        Text("My name is Ben")
          .frame(maxWidth: .infinity)
          .frame(height: 200.0)
          .background(Color.yellow)
        Text("Hello World")
          .frame(maxWidth: .infinity)
          .frame(height: 300.0)
          .background(Color.red)
        Text("My name is Ben")
          .frame(maxWidth: .infinity)
          .frame(height: 400.0)
          .background(Color.yellow)
        Text("Hello World")
          .frame(maxWidth: .infinity)
          .frame(height: 300.0)
          .background(Color.red)
        Text("My name is Ben")
          .frame(maxWidth: .infinity)
          .frame(height: 400.0)
          .background(Color.yellow)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
