//
//  MagneticScrollView.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

/** A scroll view that organizes `Block`s that's been passed to it.
   - spacing: The spacing between blocks in the scroll view. Default value is 10.
   - activeBlock: A binding to the currently active block's ID.
   - body: A closure returning the content of the scroll view.
 */
public struct MagneticScrollView<Content>: View where Content: View {
  @StateObject private var organizer : Organizer
  
  // MARK: - Properties
  var spacing: CGFloat = 8
  
  /// Anchor that's used to scroll the blocks
  var anchor: UnitPoint = .center
  
  /// The currently active block's ID
  @Binding var activeBlock: Block.ID
  
  // MARK: - Views
  private var content: Content
  
  public var body: some View {
    GeometryReader { proxy in
      ScrollViewReader { scrollViewProxy in
        OffsetObservingScrollView(offset: $organizer.scrollViewOffset) {
          // TODO: Implement block display
          VStack(spacing: organizer.spacing) {
            content
          }
        }
        .onAppear {
          organizer.prepare(with: scrollViewProxy)
        }
        .onChange(of: activeBlock) { newValue in
          organizer.activate(with: newValue)
        }
        .onChange(of: organizer.activeBlock) { newValue in
          if activeBlock != organizer.activeBlock?.id {
            activeBlock = newValue
          }
        }
      }
    }
    .environmentObject(organizer)
  }
  
  // MARK: - Initalizers
  public init(spacing: CGFloat = 10, anchor: UnitPoint = .center, activeBlock: Binding<Block.ID>, @ViewBuilder body: @escaping () -> Content) {
    self.content = body()
    self.spacing = spacing
    self.anchor = anchor
    
    // Initialize Bindings
    self._activeBlock = activeBlock
    self._organizer = StateObject(wrappedValue: Organizer(spacing: spacing, anchor: anchor))
  }
}
