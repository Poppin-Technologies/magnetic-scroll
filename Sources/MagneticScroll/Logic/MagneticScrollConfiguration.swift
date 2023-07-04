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
internal class MagneticScrollConfiguration {
  /// If the `activeBlock` should be changed on tap gesture
  var changesActiveBlockOnTapGesture: Bool = true
  /// Value that decides how `MagneticScrolLView` should react to `Velocity` of `ScrollView`
  var scrollVelocityThreshold: Double = 0.9
  ///
  var triggersHapticFeedbackOnBlockChange = true
  ///
  var scrollAnimationDuration: Double = 0.35
  
  var formStyle = false
  
  
  // singleton
  static let shared = MagneticScrollConfiguration()
  
  private init() {
    
  }
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
