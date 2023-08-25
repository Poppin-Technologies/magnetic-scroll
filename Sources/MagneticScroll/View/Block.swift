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
  
  @EnvironmentObject var organizer: MagneticOrganizer
  @EnvironmentObject var configuration: MagneticScrollConfiguration
  
  // MARK: - State
  
  /// The height of this block.
  /// This value is used to calculate where the block is positioned in the scroll view.
  var height: CGFloat = .zero
  var inActiveHeight: CGFloat = .zero
  
  @State private var viewHeight: CGFloat = .zero
  
  // MARK: - Binding
  
  /// Whether or not block is shown
  @Binding var isShown: Bool
  
  // MARK: - Properties
  
  /// The ID of this block.
  /// The underlying `body` property attaches to this ID.
  public var id: String = ""
  
  /// The content to display.
  /// This is a type-erased view.
  var content: Content
  
  // MARK: - Private Properties
  
  private var magneticBlock: MagneticBlock {
    .init(id: id, height: isShown ? (isActive ? (viewHeight == .zero ? height : viewHeight) : inActiveHeight) : 0)
  }
  
  private var isActive: Bool {
    return organizer.activeBlock?.id == id
  }
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      if isShown {
        VStack {
          content
            .readSize { size in
              if isActive {
                guard height.isZero else { return }
                self.viewHeight = size.height
              }
              else {
                guard inActiveHeight.isZero else { return }
                self.viewHeight = size.height
              }
            }
            .frame(height: magneticBlock.height)
            .frame(maxWidth: .infinity)
        }
      }
    }
    .contentShape(Rectangle())
    .simultaneousGesture(
      TapGesture()
        .onEnded {
          if configuration.changesActiveBlockOnTapGesture {
            if configuration.formStyle && !organizer.isScrolling { return }
            organizer.activeBlock = magneticBlock
            organizer.scrollTo(block: magneticBlock)
          }
        }
    )
    .animation(.spring(), value: magneticBlock.height)
    .id(id)
    .onAppear {
      organizer.feed(with: magneticBlock)
    }
    
    .onChange(of: organizer.activeBlock) { activeBlock in
      organizer.update(block: magneticBlock)
    }
    
    .onChange(of: isShown) { _ in
      organizer.update(block: magneticBlock)
    }
  }
  
  // MARK: - Initalizers
  
  public init(
    id: String = "",
    height: CGFloat = .zero,
    inActiveHeight: CGFloat = .zero,
    isShown: Binding<Bool> = .constant(true),
    @ViewBuilder body: @escaping () -> Content
  ) {
    self.content = body()
    self.id = id
    self._isShown = isShown
    self.inActiveHeight = inActiveHeight
    self.height = height
  }
}

public extension Block {
  typealias ID = String
}
