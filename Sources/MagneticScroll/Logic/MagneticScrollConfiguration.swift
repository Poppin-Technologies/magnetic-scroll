//
//  MagneticScrollConfiguration.swift
//  
//
//  Created by Demirhan Mehmet Atabey on 3.07.2023.
//

import Foundation

/**
 Configuration for `MagneticScrollView`
 */
internal class MagneticScrollConfiguration: ObservableObject {
  /// If the `activeBlock` should be changed on tap gesture
  @Published var changesActiveBlockOnTapGesture: Bool = true
  /// Value that decides how `MagneticScrolLView` should react to `Velocity` of `ScrollView`
  @Published var scrollVelocityThreshold: Double = 0.9
  /// Determines whether haptic feedback should be triggered when any  block is scrolled.
  @Published var triggersHapticFeedbackOnBlockChange = true
  /// The duration of the scroll animation when changing the active block.
  @Published var scrollAnimationDuration: Double = 0.35
  /// Determines whether haptic feedback should be triggered when the active block changes.
  @Published var triggersHapticFeedbackOnActiveBlockChange = false
  /// If the form style should be enabled or not.
  @Published var formStyle = false
  /// The timeout duration to change a block to another.
  @Published var timeoutNeeded: Double = 0.39
}


extension MagneticScrollConfiguration : Equatable {
  static func == (lhs: MagneticScrollConfiguration, rhs: MagneticScrollConfiguration) -> Bool {
    return (
      lhs.changesActiveBlockOnTapGesture == rhs.changesActiveBlockOnTapGesture &&
      lhs.scrollVelocityThreshold == rhs.scrollVelocityThreshold &&
      lhs.triggersHapticFeedbackOnBlockChange == rhs.triggersHapticFeedbackOnBlockChange &&
      lhs.scrollAnimationDuration == rhs.scrollAnimationDuration &&
      lhs.formStyle == rhs.formStyle
    )
  }
}
