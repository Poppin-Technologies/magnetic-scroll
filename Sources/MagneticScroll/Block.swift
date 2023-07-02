//
//  Block.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

/**
 A magnetic scroll block.
 
 ``MagneticScrollView`` displays a vertical stack of blocks.
 */
@available(iOS 14.0, *)
public struct Block<Content>: View where Content: View {
  
  // MARK: - Organizer
  
  /// Organizer that is supplied by MagneticScrollView
  @EnvironmentObject var organizer: Organizer
  
  // MARK: - State
  
  /// The height of this block.
  /// This value is used to calculate where the block is positioned in the scroll view.
  @State var height: CGFloat = .zero
  
  // MARK: - Binding
  
  /// Binding to set height of the `Block`
  @Binding var heightBinding: CGFloat
  
  /// Whether or not block is shown
  @Binding var isShown: Bool
  
  // MARK: - Properties
  
  /// The ID of this block.
  /// The underlying `body` property attaches to this ID.
  public var id: AnyHashable?
  
  /// The content to display.
  /// This is a type-erased view.
  var content: Content
  
  // MARK: - Private Properties
  
  private var magneticBlock: MagneticBlock {
    .init(id: id, height: isShown ? height : 0)
  }
  
  // MARK: - Views
  public var body: some View {
    ZStack {
      if isShown {
        VStack {
          content
            .readSize { size in
              guard height.isZero else { return }
              self.height = size.height
            }
        }
      }
    }
//    .animation(.spring(), value: height)
    .id(id)
    
    .onAppear {
      organizer.feed(with: magneticBlock)
    }
    
    .onChange(of: heightBinding) { newValue in
      self.height = newValue
    }
    
    .onChange(of: height) { _ in
      organizer.update(block: magneticBlock)
    }
    
    .onChange(of: isShown) { _ in
      organizer.update(block: magneticBlock)
    }
  }
  
  // MARK: - Initalizers
  
  public init(id: AnyHashable = UUID(), height: Binding<CGFloat> = .constant(.zero), isShown: Binding<Bool> = .constant(true), @ViewBuilder body: @escaping () -> Content) {
    self.content = body()
    self.id = id
    
    self._heightBinding = height
    self._isShown = isShown
    
    self.height = height.wrappedValue
  }
}

public extension Block {
  typealias ID = AnyHashable?
}
