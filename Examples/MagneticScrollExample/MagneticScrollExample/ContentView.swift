//
//  ContentView.swift
//  MagneticScrollExample
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI
import MagneticScroll

struct MultipleBlocksView: View {
  @Namespace var MagneticBlockNameSpace
  @State private var activeBlock: Block.ID = "First"
  
  let ids = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth"
  ]
  
  let color = Color(red: 0.48, green: 0.24, blue: 0.75)
  
  var body: some View {
    ScrollViewReader { proxy in
      MagneticScrollView(activeBlock: $activeBlock) { organizer in
        ForEach(ids, id: \.self) { id in
          Block(id: id, height: 600, inActiveHeight: 450) {
            VStack(spacing: 10.0) {
              if activeBlock == id {
                Text("This is a header")
                  .font(.title2)
                  .fontWeight(.bold)
                  .foregroundColor(color)
                  .frame(maxWidth: .infinity, alignment: .center)
                //                .matchedGeometryEffect(id: "Header", in: MagneticBlockNameSpace)
              }
              Spacer()
              TextField("Input info here", text: .constant(""), onCommit: {
                // Next block
              })
              .padding()
              .border(.black)
              .background(Color.init(white: 0.05))
              .cornerRadius(16)
              Spacer()
              
              if activeBlock == id {
                VStack {
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
                //              .matchedGeometryEffect(id: "Content", in: MagneticBlockNameSpace)
                
              }
            }
            .padding()
          }
          .frame(maxWidth: .infinity)
          .background(Color(.systemGray6))
          .cornerRadius(16)
          .overlay {
            Group {
              if activeBlock == id {
                RoundedRectangle(cornerRadius: 16)
                  .stroke(lineWidth: 1)
                  .foregroundColor(color)
              }
            }
          }
          .padding(1)
          .animation(.spring(response: 0.3, dampingFraction: 1.2), value: activeBlock)
        }
      }
      .formStyle()
      .setTimeout(0.20)
      .padding(.horizontal)
      .background(Color.black)
      .preferredColorScheme(.dark)
    }
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
      MagneticScrollView(activeBlock: $activeBlock) { organizer in
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
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
