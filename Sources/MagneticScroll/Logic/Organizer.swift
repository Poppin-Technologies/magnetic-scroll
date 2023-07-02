//
//  Organizer.swift
//
//
//  Created by Demirhan Mehmet Atabey on 29.06.2023.
//

import SwiftUI
import Combine
import OrderedCollections

/// Organizer to control `Block`s. Supplied by `MagneticScrollView` to all subviews.
@available(iOS 14.0, *)
@MainActor internal class Organizer: ObservableObject {
  
  // MARK: Wrapped Properties
  
  /// Blocks that's been passed to`MagneticScrollView`
  @Published var blocks: OrderedSet<MagneticBlock> = OrderedSet<MagneticBlock>()
  /// `MagneticScrollView`s current offset
  @Published var scrollViewOffset: CGPoint = .zero
  /// Current active block
  @Published var activeBlock: MagneticBlock? = nil
  /// Spacing between `Blocks`. Used in calculation
  var spacing: CGFloat
  /// Anchor that blocks will use
  var anchor: UnitPoint
  
  var disableMagneticScroll: Bool = false
  
  // MARK: - Private variables
  
  private var cancellables = Set<AnyCancellable>()
  private var proxy: ScrollViewProxy? = nil
  private var previousOffset: CGFloat = 0.0

  
  var blocksToActiveBlock : [MagneticBlock] {
    guard let activeBlock = activeBlock else { return [] }
    guard let indexOfActiveBlock = blocks.firstIndex(of: activeBlock), indexOfActiveBlock != 0 else { return [] }
    return Array(blocks.prefix(upTo: indexOfActiveBlock))
  }
  
  var blocksFromActiveBlock : [MagneticBlock] {
    guard let activeBlock = activeBlock else { return [] }
    guard let indexOfActiveBlock = blocks.firstIndex(of: activeBlock), indexOfActiveBlock != blocks.count - 1 else { return [] }
    return Array(blocks.suffix(from: (indexOfActiveBlock + 1)))
  }
  
  var offsetUntilActiveBlock : CGFloat {
    guard let activeBlock = activeBlock else { return 0.0 }
    var height: CGFloat = 0.0
    
    for block in blocks.prefix(upTo: blocks.firstIndex(of: activeBlock) ?? 0) {
      height += block.height
    }
    
    return height
  }
  
  // MARK: - Initializers
  
  /// Initializes the `Organizer`.
  /// - Parameters:
  ///   - spacing: The spacing between blocks. Default value is 8.
  ///   - anchor: The anchor point that blocks will use. Default value is `.center`.
  init(spacing: CGFloat, anchor: UnitPoint) {
    self.spacing = spacing
    self.anchor = anchor
    self.setupPublishers()
  }
  
  /** Feeds the `Organizer` with the given `MagneticBlock`.
   - Parameter block: The `MagneticBlock` to feed to the organizer.
  */
  func feed(with block: MagneticBlock) {
    blocks.updateOrInsert(block, at: 0)
  }
  
  /**
   Prepares the `Organizer` with the given `ScrollViewProxy`.
   - Parameter proxy: The `ScrollViewProxy` to prepare with.
  */
  func prepare(with proxy: ScrollViewProxy) {
    self.proxy = proxy
  }
  
  /**
    Activates the block with the specified ID.
    - Parameter id: The ID of the block to activate.
   */
  func activate(with id: Block.ID) {
    guard let block = blocks.first(where: { $0.id == id }) else { return }
    
    self.activeBlock = block
    self.scrollTo(block: block)
  }
  
  /**
   Updates the given block in the `Organizer`.
   - Parameter block: The block to update.
  */
  func update(block: MagneticBlock) {
    blocks.updateOrAppend(block)
  }
  
  /**
   Replaces the given block with a new block in the `Organizer`.
   - Parameters:
     - block: The block to replace.
     - newBlock: The new block to insert.
  */
  func replace(block: MagneticBlock, with newBlock: MagneticBlock) {
    guard let blockIndex = blocks.firstIndex(of: block) else { return }
    
    blocks.remove(at: blockIndex)
    blocks.insert(newBlock, at: blockIndex)
  }
  
  // MARK: - Private Methods

  private func setupPublishers() {
    $scrollViewOffset
      .debounce(for: 0.05, scheduler: DispatchQueue.main)
      .sink { [weak self] scrollViewOffset in
        guard let self = self else { return }
        
        if !self.disableMagneticScroll {
          self.scrollToOffset()
        }
      }
      .store(in: &cancellables)
  }
}


// MARK: - Scroll Handler
extension Organizer {
  func scrollTo(block: MagneticBlock) {
    
    guard let scrollProxy = proxy else { return }
    
    DispatchQueue.main.async {
      withAnimation(.interpolatingSpring(stiffness: 353, damping: 12343)) {
        /**
         this is to prevent proxy.scrollTo, to be detected as scroll behavior by the algorithm
         the reason is that when proxy.scrollTo gets triggered, the `scrollViewOffset` changes at the same time and this gets detected as a scroll behavior and this causes an infinite scroll loop
         */
        if !self.disableMagneticScroll {
          self.activeBlock = block
          generateHapticFeedback()
          scrollProxy.scrollTo(block.id, anchor: self.anchor)

          self.disableMagneticScroll = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.39) {
            self.disableMagneticScroll = false
          }
        }
      }
    }
  }
}

// MARK: - Activation Handler
extension Organizer {
  func scrollToOffset() {
    guard blocks.count > 0 else { print("No block is present in MagneticScroll"); return }
    
    if activeBlock == nil {
      activeBlock = blocks[0]
    }
    
    let nonActivatedOffset = (scrollViewOffset.y - offsetUntilActiveBlock)
    
    if nonActivatedOffset > 0 {
      if nonActivatedOffset > (activeBlock!.height / 2) {
        var scrolledOffset: CGFloat = 0.0
        
        for (index, block) in blocksFromActiveBlock.enumerated() {
          if index == blocksFromActiveBlock.count - 1 {
            self.scrollTo(block: block)
            return
          }
          
          let nextBlock = blocksFromActiveBlock[index]
          let shouldScroll = nonActivatedOffset <= (scrolledOffset + nextBlock.height)
          
//          print("NonActivatedOffset: \(nonActivatedOffset)")
//          print("ScrolledOffset: \(scrolledOffset)")
//          print("NextBlockHeight: \(nextBlock.height)")
          
          if shouldScroll {
            self.scrollTo(block: block)
            return
          }
          else {
            scrolledOffset += nextBlock.height
          }
        }
      }
    }
    else {
      if nonActivatedOffset < (-1 * (activeBlock!.height / 2)) {
        var scrolledOffset: CGFloat = 0.0
        
        let blocksToActivateBlock = blocksToActiveBlock.reversed()
        for (index, block) in blocksToActivateBlock.enumerated() {
          if index == blocksToActivateBlock.count - 1 {
            self.scrollTo(block: block)
            return
          }
          
          let previousBlock = blocksToActiveBlock[index + 1]
//          print("NonActivatedOffset: \(nonActivatedOffset)")
//          print("ScrolledOffset: \(scrolledOffset)")
//          print("PreviousBlockHeight: \(previousBlock.height)")
          
          if nonActivatedOffset < (scrolledOffset + (previousBlock.height * -1)) {
            scrolledOffset += previousBlock.height * -1
          }
          else {
            self.scrollTo(block: block)
            return
          }
        }
        
      }
    }
  }
}


extension Organizer {
  func triggerHapticFeedbackOnBlockChange() {
    guard let activeBlock = activeBlock else { return }
    
      
  }
}
