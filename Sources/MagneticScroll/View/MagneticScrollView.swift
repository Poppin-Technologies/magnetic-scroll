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
  
  /// Whether the ScvrollView should show indicators.
  var showsIndicators: Bool = false
  
  /// The currently active block's ID
  @Binding var activeBlock: Block.ID
  
  /// Optional proxy supplied to the `MagneticScrollView`, if empty, magneticscroll will automatically create a scrollViewProxy.
  var proxy: ScrollViewProxy?
  
  // MARK: - Views
  
  private var content: (MagneticOrganizer) -> Content
  
  // MARK: - Private Properties
  
  @StateObject private var organizer: MagneticOrganizer
  @ObservedObject private var configuration = MagneticScrollConfiguration()
  
  @ViewBuilder
  public var body: some View {
    OptionalScrollViewReader(proxy: proxy) { scrollViewProxy in
      OffsetObservingScrollView(showsIndicators: showsIndicators, offset: $organizer.scrollViewOffset) {
        VStack(spacing: organizer.spacing) {
          content(organizer)
        }
      }
      .onAppear {
        organizer.prepare(with: scrollViewProxy, configuration: configuration)
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
    .environmentObject(organizer)
    .environmentObject(configuration)
  }
  
  // MARK: - Initalizers
  /**
   - Parameter spacing: The spacing between blocks in the scroll view. Default value is 10.
   - Parameter activeBlock: A binding to the currently active block's ID.
   - Parameter body: A closure returning the content of the scroll view.
   */
  public init(
    spacing: CGFloat = 10,
    anchor: UnitPoint = .center,
    proxy: ScrollViewProxy? = nil,
    activeBlock: Binding<Block.ID>,
    @ViewBuilder content: @escaping (MagneticOrganizer) -> Content
  ) {
    self.content = content
    self.spacing = spacing
    self.anchor = anchor
    self.proxy = proxy
    
    // Initialize Bindings
    self._activeBlock = activeBlock
    self._organizer = StateObject(wrappedValue: MagneticOrganizer(spacing: spacing, anchor: anchor))
  }
}

private struct OptionalScrollViewReader<Content: View>: View {
  var proxy: ScrollViewProxy?
  
  @ViewBuilder var content: (ScrollViewProxy) -> Content
  
  @ViewBuilder
  var body: some View {
    if let proxy {
      content(proxy)
    } else {
      ScrollViewReader { scrollViewProxy in
        content(scrollViewProxy)
      }
    }
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
    configuration.changesActiveBlockOnTapGesture = value
    return self
  }
  
  /**
   Sets the velocity threshold for `MagneticScrollView` to react to scroll view velocity, if you get a junky behavior from `MagneticScrollView`, play with this value.
   
   - Parameters:
     - threshold: A `Double` value representing the scroll velocity threshold.
                  Higher values result in faster scrolling to the calculated block,
                  while lower values result in slower scrolling to the calculated block. By default, it is 0.9.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func velocityThreshold(_ threshold: Double) -> MagneticScrollView {
    configuration.scrollVelocityThreshold = threshold
    return self
  }
  
  /**
   Sets whether haptic feedback should be triggered when the active block changes.
   
   - Parameters:
     - bool: A Boolean value indicating whether haptic feedback should be triggered on block change. Default value is `true`.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func triggersHapticFeedbackOnBlockChange(_ bool: Bool = true) -> MagneticScrollView {
    configuration.triggersHapticFeedbackOnBlockChange = bool
    return self
  }
  
  
  /**
   Sets whether haptic feedback should be triggered when the active block changes.
   
   - Parameters:
     - bool: A Boolean value indicating whether haptic feedback should be triggered on block change. Default value is `true`.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func triggersHapticFeedbackOnActiveBlockChange(_ bool: Bool = true) -> MagneticScrollView {
    configuration.triggersHapticFeedbackOnActiveBlockChange = bool
    return self
  }
 
  /**
   Sets whether the form style should be enabled or not.

   The `formStyle` configuration allows you to change the blocks by tapping when scrolling but not when not scrolling.
   */
  func formStyle(_ bool: Bool = true) -> MagneticScrollView {
    configuration.formStyle = bool
    return self
  }
  
  /**
   Sets the scroll animation duration when changing the active block.
   
   - Parameters:
     - duration: A double value representing the scroll animation duration in seconds.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func scrollAnimationDuration(_ duration: Double) -> MagneticScrollView {
    configuration.scrollAnimationDuration = duration
    return self
  }
  
  /**
   The timeout duration needed to change a block to another.
   
   - Parameters:
     - duration: A double value representing the timeout duration in seconds.
   
   - Returns: The `MagneticScrollView` instance with the updated configuration.
   */
  func setTimeout(_ duration: Double) -> MagneticScrollView {
    configuration.timeoutNeeded = duration
    return self
  }
}


