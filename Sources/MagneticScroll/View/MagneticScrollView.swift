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
   Sets whether the active block should be changed on tap gesture.
   
   - Parameters:
     - value: A Boolean value indicating whether the active block should be changed on tap gesture. Default value is `true`.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func changesActiveBlockOnTapGesture(_ value: Bool = true) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.changesActiveBlockOnTapGesture = value
    return self
  }
  
  /**
   Sets the velocity threshold for `MagneticScrollView` to react to scroll view velocity.
   
   - Parameters:
     - threshold: A double value representing the scroll velocity threshold.
                  Higher values result in faster scrolling to the calculated block,
                  while lower values result in slower scrolling to the calculated block.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func velocityThreshold(_ threshold: Double) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.scrollVelocityThreshold = threshold
    return self
  }
  
  /**
   Sets whether haptic feedback should be triggered when the active block changes.
   
   - Parameters:
     - bool: A Boolean value indicating whether haptic feedback should be triggered on block change. Default value is `true`.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func triggersHapticFeedbackOnBlockChange(_ bool: Bool = true) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.triggersHapticFeedbackOnBlockChange = bool
    return self
  }
  
  
  /**
   Sets whether haptic feedback should be triggered when the active block changes.
   
   - Parameters:
     - bool: A Boolean value indicating whether haptic feedback should be triggered on block change. Default value is `true`.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func triggersHapticFeedbackOnActiveBlockChange(_ bool: Bool = true) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.triggersHapticFeedbackOnActiveBlockChange = bool
    return self
  }
 
  /**
   Sets whether the form style should be enabled or not.

   The `formStyle` configuration allows you to change the blocks by tapping when scrolling but not when not scrolling.
   */
  func formStyle(_ bool: Bool = true) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.formStyle = bool
    return self
  }
  
  /**
   Sets the scroll animation duration when changing the active block.
   
   - Parameters:
     - duration: A double value representing the scroll animation duration in seconds.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func scrollAnimationDuration(_ duration: Double) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.scrollAnimationDuration = duration
    return self
  }
  
  /**
   The timeout duration needed to change a block to another.
   
   - Parameters:
     - duration: A double value representing the timeout duration in seconds.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func setTimeout(_ duration: Double) -> MagneticScrollView {
    MagneticScrollConfiguration.shared.timeoutNeeded = duration
    return self
  }
}


