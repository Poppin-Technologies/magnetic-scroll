//
//  Organizer.swift
//  
//
//  Created by Demirhan Mehmet Atabey on 29.06.2023.
//

import Combine
import OrderedCollections

/// Organizer to control `Block`s. Supplied by `MagneticScrollView` to all subviews.
@available(iOS 14.0, *)
internal class Organizer: ObservableObject {
  @Published var blocks = OrderedSet<MagneticBlock>()
  var cancellables = Set<AnyCancellable>()
  
  func feed(with block: MagneticBlock) {
    blocks.updateOrInsert(block, at: 0)
  }
  
  /// For testing, should be deleted when releasing
  init() {
    $blocks.sink { newValue in
      print("Block changed: \(newValue)")
    }
    .store(in: &cancellables)
  }
  
  
  func update(block: MagneticBlock) {
    blocks.updateOrAppend(block)
  }
}
