//
//  Organizer.swift
//  
//
//  Created by Demirhan Mehmet Atabey on 29.06.2023.
//

import CoreGraphics
import Combine
import OrderedCollections

/// Organizer to control `Block`s. Supplied by `MagneticScrollView` to all subviews.
@available(iOS 14.0, *)
internal class Organizer: ObservableObject {
  @Published var blocks = OrderedSet<MagneticBlock>()
  @Published var scrollViewOffset: CGPoint = .zero
  
  @Published var activeBlock: MagneticBlock? = nil
  @Published var activatedOffset: CGFloat = 0
  
  // MARK: - Private variables
  private var cancellables = Set<AnyCancellable>()
  
  var spacing: CGFloat
  
  func feed(with block: MagneticBlock) {
    blocks.updateOrInsert(block, at: 0)
  }
  
  /// For testing, should be deleted when releasing
  init(spacing: CGFloat) {
    self.spacing = spacing
    
    $blocks.sink { newValue in
//      print("Block changed: \(newValue)")
    }
    .store(in: &cancellables)
    
    $scrollViewOffset.sink { [weak self] scrollviewOffset in
//      print("scrollviewOffset has changed: \(scrollviewOffset)")
      self?.checkIfBlockShouldBeActivated()
    }
    .store(in: &cancellables)
  }
  
  func setupPublishers() {
    $activeBlock.sink { [weak self] block in
      if let block {
        self?.activatedOffset += block.height
      }
    }
    .store(in: &cancellables)
  }
  
  
  func update(block: MagneticBlock) {
    blocks.updateOrAppend(block)
  }
  
  func checkIfBlockShouldBeActivated() {
    guard self.blocks.count > 0 else { return }

    if activeBlock == nil {
      self.activeBlock = blocks[0]
    }
    
    guard self.blocks.count > 1 else { return }
    guard let blockIndex = blocks.firstIndex(of: activeBlock!) else { return }
    
    
    var nextBlock: MagneticBlock
    
    if blockIndex == blocks.count - 1 {
      nextBlock = blocks[blockIndex]
    }
    else {
      nextBlock = blocks[blockIndex + 1]
    }
        
    let nonActivatedOffset = self.scrollViewOffset.y - (activatedOffset + spacing)
    
    if nonActivatedOffset > (activeBlock!.height / 2) {
      activeBlock = nextBlock
    }
    
    print(blocks)
    print(activeBlock)
    print(nonActivatedOffset)
  }
}
