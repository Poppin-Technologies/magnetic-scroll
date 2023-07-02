//
//  ContentView.swift
//  MagneticScrollExample
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI
import MagneticScroll

struct ContentView: View {
  @State private var activeBlock : Block.ID = "First"
  
  var body: some View {
    VStack {
      ScrollViewReader { proxy in
        MagneticScrollView(activeBlock: $activeBlock) {
          Block(id: "scroll field") {
            Button("Scroll To Bottom") {
              activeBlock = "Fifth"
            }
            .frame(width: viewBounds().width, height: viewBounds().height * 0.7)
            .background(Color.blue)
          }
          Block(id: "First") {
            Text("First Block")
            .frame(width: viewBounds().width, height: viewBounds().height * 0.7)
            .background(Color.blue)

          }
          Block(id: "Second") {
            Text("Second Block")
            .frame(width: viewBounds().width, height: viewBounds().height * 0.7)
            .background(Color.blue)

          }
          Block(id: "Third") {
            Text("Third Block")
              .frame(width: viewBounds().width, height: viewBounds().height * 0.7)
              .background(Color.blue)

          }
          
          Block(id: "Fourth") {
            Text("Fourth Block")
              .frame(width: viewBounds().width, height: viewBounds().height * 0.7)
              .background(Color.blue)
          }
          
          Block(id: "Fifth") {
            Button("Top") {
              activeBlock = "scroll field"
            }
            .frame(width: viewBounds().width, height: viewBounds().height * 0.7)
            .background(Color.red)

          }
        }
      }
    }
  }
  
  func viewBounds() -> CGRect {
    return UIScreen.main.bounds
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
