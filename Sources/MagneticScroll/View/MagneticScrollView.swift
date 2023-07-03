//
//  MagneticScrollView.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

/** A scroll view that organizes `Block`s that's been passed to it.
 */
public struct MagneticScrollView<Content>: View where Content: View {
  // MARK: - Properties
  var spacing: CGFloat = 8
  
  /// Anchor that's used to scroll the blocks
  var anchor: UnitPoint = .center
  
  /// The currently active block's ID
  @Binding var activeBlock: Block.ID
  
  // MARK: - Views
  private var content: Content
  
  // MARK: - Private Properties
  @StateObject private var organizer : Organizer
  
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
        .onChange(of: organizer.activeBlock) { block in
          guard let block = block else { return }
          if activeBlock != organizer.activeBlock?.id {
            activeBlock = block.id
          }
        }
      }

    }
    .environmentObject(organizer)
  }
  
  // MARK: - Initalizers
  /**
   - Parameter spacing: The spacing between blocks in the scroll view. Default value is 10.
   - Parameter activeBlock: A binding to the currently active block's ID.
   - Parameter body: A closure returning the content of the scroll view.
   */
  public init(spacing: CGFloat = 10, anchor: UnitPoint = .center, activeBlock: Binding<Block.ID>, @ViewBuilder body: @escaping () -> Content) {
    self.content = body()
    self.spacing = spacing
    self.anchor = anchor
    
    // Initialize Bindings
    self._activeBlock = activeBlock
    self._organizer = StateObject(wrappedValue: Organizer(spacing: spacing, anchor: anchor))
  }
}



// MARK: - View Extensions

public extension MagneticScrollView {
  /**
   
   */
  func changesActiveBlockOnTapGesture(_ value: Bool = true) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.changesActiveBlockOnTapGesture = value
    return self
  }
  
  /**
    
   */
  func velocityThreshold(_ threshold: Double) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.scrollVelocityThreshold = threshold
    return self
  }
  
  /**
    
   */
  func triggersHapticFeedbackOnBlockChange(_ bool: Bool = true) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.triggersHapticFeedbackOnBlockChange = bool
    return self
  }
  
  
  func scrollAnimationDuration(_ duration: Double) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.scrollAnimationDuration = duration
    return self
  }
}

