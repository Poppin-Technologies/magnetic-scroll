//
//  ContentView.swift
//  MagneticScrollExample
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI
import MagneticScroll


struct MultipleBlocksView: View {
  let ids = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth"]
  @State private var activeBlock: Block.ID = "First"
  var body: some View {
    MagneticScrollView(activeBlock: $activeBlock) {
      ForEach(ids, id: \.self) { id in
        Block(id: id, height: 600, inActiveHeight: 400) {
          VStack(spacing: 10.0) {
            if activeBlock == id {
              Text("This is a header").font(.title2)
            }
            TextField("Input info here", text: .constant(""), onCommit: {
              // Next block
            })
            .padding()
              .border(.black)
            if activeBlock == id {
              Text("This is secondary info").opacity(0.5)
              Button("Prev Block") {
                let i = ids.firstIndex(of: activeBlock)!
                self.activeBlock = ids[i - 1]
              }
              .disabled(ids.firstIndex(of: activeBlock)! == 0)
              Button("Next Block") {
                let i = ids.firstIndex(of: activeBlock)!
                self.activeBlock = ids[i + 1]
              }
              .disabled(ids.firstIndex(of: activeBlock)! == ids.count - 1)
            }
          }
          .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.3))
      }
    }
    .formStyle()
    .setTimeout(0.15)
  }
}

struct ContentView: View {
  var body: some View {
    MultipleBlocksView()
  }
}

struct SingleBlocksView: View {
  @State private var activeBlock : Block.ID = "First"
  @State private var height: CGFloat = 200
  var body: some View {
    VStack {
      MagneticScrollView(activeBlock: $activeBlock) {
        Block(id: "scroll field", height: 400, inActiveHeight: 600) {
          Button("Scroll To Bottom") {
            activeBlock = "Fifth"
          }
          .frame(maxWidth: .infinity)
        }
        .background(Color.green)
        Block(id: "First", height: 400, inActiveHeight: 600) {
          Text("First Block")
            .frame(maxWidth: .infinity)
        }
        
        .background(Color.blue)
        
        Block(id: "Second", height: 400, inActiveHeight: 600) {
          Text("Second Block")
            .frame(maxWidth: .infinity)
        }
        .background(Color.blue)
        
        Block(id: "Third", height: 400, inActiveHeight: 600) {
          Text("Third Block")
            .frame(maxWidth: .infinity)
        }
        .background(Color.blue)
        
        Block(id: "Fourth", height: 400, inActiveHeight: 600) {
          Text("Fourth Block")
        }
        .background(Color.blue)
        
        Block(id: "Fifth", height: 400, inActiveHeight: 600) {
          Button("Top") {
            activeBlock = "scroll field"
          }
          .background(Color.red)
          
        }
      }
      .changesActiveBlockOnTapGesture()
      .triggersHapticFeedbackOnBlockChange()
      .velocityThreshold(1.0)
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
