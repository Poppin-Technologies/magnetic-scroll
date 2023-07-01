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
  @Published var blocks = OrderedSet<MagneticBlock>()
  @Published var scrollViewOffset: CGPoint = .zero
  
  @Published var activeBlock: MagneticBlock? = nil
  @Published var activatedOffset: CGFloat = 0
  
  // MARK: - Private variables
  private var cancellables = Set<AnyCancellable>()
  private var proxy: ScrollViewProxy? = nil
  private var previousOffset: CGFloat = 0.0
  
  var spacing: CGFloat
  
  var disableMagneticScroll: Bool = false
  
  
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
  
  init(spacing: CGFloat) {
    self.spacing = spacing
    self.setupPublishers()
  }
  
  func feed(with block: MagneticBlock) {
    blocks.updateOrInsert(block, at: 0)
  }
  
  func prepare(with proxy: ScrollViewProxy) {
    self.proxy = proxy
  }
  
  func activate(with id: Block.ID) {
    guard let block = blocks.first(where: { $0.id == id }) else { return }
    
    self.activeBlock = block
    self.scrollTo(block: block)
  }
  
  func update(block: MagneticBlock) {
    blocks.updateOrAppend(block)
  }
  
  func replace(block: MagneticBlock, with newBlock: MagneticBlock) {
    guard let blockIndex = blocks.firstIndex(of: block) else { return }
    
    blocks.remove(at: blockIndex)
    blocks.insert(newBlock, at: blockIndex)
  }
  
  func setupPublishers() {
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
  func scrollTo(block: MagneticBlock, anchor: UnitPoint = .center) {
    
    guard let scrollProxy = proxy else { return }
    
    DispatchQueue.main.async {
      withAnimation(.spring()) {
        /**
         this is to prevent proxy.scrollTo, to be detected as scroll behavior by the algorithm
         the reason is that when proxy.scrollTo gets triggered, the `scrollViewOffset` changes at the same time and this gets detected as a scroll behavior and this causes an infinite scroll loop
         */
        if !self.disableMagneticScroll {
          self.activeBlock = block
          generateHapticFeedback()
          scrollProxy.scrollTo(block.id, anchor: anchor)

          
          DispatchQueue.main.async {
            self.disableMagneticScroll = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.39) {
              self.disableMagneticScroll = false
            }
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

