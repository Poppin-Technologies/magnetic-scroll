//
//  Haptic.swift
//  
//
//  Created by Demirhan Mehmet Atabey on 30.06.2023.
//

import UIKit
import AudioToolbox

func generateHapticFeedback() {
  AudioServicesPlaySystemSound(1519)
}

func generateSelectedFeedback() {
  let feedbackGenerator = UISelectionFeedbackGenerator()
  feedbackGenerator.prepare()
  feedbackGenerator.selectionChanged()
}
