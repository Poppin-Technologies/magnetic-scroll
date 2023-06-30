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
  
  var nonActivatedOffset: CGFloat {
    scrollViewOffset.y - activatedOffset + (activeBlock?.height ?? 0) / 4
  }
  
  var absoluteDistanceToPreviousBlock: CGFloat {
    abs(scrollViewOffset.y - (activatedOffset - blocks[0].height - spacing))
  }
  
  init(spacing: CGFloat) {
    self.spacing = spacing
    setupPublishers()
  }
  
  func feed(with block: MagneticBlock) {
    blocks.updateOrInsert(block, at: 0)
  }
  
  func prepare(with proxy: ScrollViewProxy) {
    self.proxy = proxy
  }
  
  func activate(with id: Block.ID) {
    guard let block = blocks.first(where: { $0.id == id }) else { print("Block with ID '\(String(describing: id))' could not be found."); return }
    
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
    $activeBlock
      .sink { [weak self] block in
      guard let strongSelf = self, let block = block else { return }
      strongSelf.activatedOffset += block.height + strongSelf.spacing
    }
    .store(in: &cancellables)
    
    $scrollViewOffset
      .debounce(for: 0.1, scheduler: DispatchQueue.main)
      .sink { [weak self] scrollViewOffset in
        guard let self = self else { return }
        
        self.checkIfNextBlockShouldBeActivated()
        
        if self.scrollViewOffset.y > self.previousOffset {
          self.checkIfNextBlockShouldBeActivated()
        }
        else {
          self.checkIfPreviousBlockShouldBeActivated()
        }
        
        self.previousOffset = scrollViewOffset.y
      }
      .store(in: &cancellables)
  }
}


// MARK: - Scroll Handler
extension Organizer {
  func scrollTo(block: MagneticBlock, anchor: UnitPoint = .center, upwards : Bool = false) {
    self.activeBlock = block
    
    if upwards {
      self.activatedOffset -= block.height * 2
    }
    
    guard let scrollProxy = proxy else { return }
    
    DispatchQueue.main.async {
      withAnimation(.spring()) {
        scrollProxy.scrollTo(block.id, anchor: anchor)
        generateHapticFeedback()
      }
    }
  }
}

// MARK: - Activation Handler
extension Organizer {
  func checkIfPreviousBlockShouldBeActivated() {

//    print("Scrolling Upwards!")
//    print("Active Block Height", activeBlock?.height)
//    print("ScrollView Offset", scrollViewOffset.y)
//    print("Activated Offset", activatedOffset)
    guard blocks.count > 0 else { return }

    if activeBlock == nil {
      activeBlock = blocks[0]
    }
    
    guard let activeBlock = activeBlock, let blockIndex = blocks.firstIndex(of: activeBlock) else { return }
    
    let previousBlockIndex: Int
   
    if blockIndex == 0 {
      previousBlockIndex = 0
    }
    else {
      previousBlockIndex = blockIndex - 1
    }
    
    let previousBlock = blocks[previousBlockIndex]
    
    if absoluteDistanceToPreviousBlock > (activeBlock.height / 2) {
      if absoluteDistanceToPreviousBlock > activeBlock.height {
        let filteredBlocks = Array(blocks.prefix(upTo: blockIndex))
        for (index, block) in filteredBlocks.enumerated() {
          if index != 0 {
            let previousBlock = filteredBlocks[index - 1]
            
            if absoluteDistanceToPreviousBlock > (previousBlock.height / 2) {
              self.activatedOffset -= block.height
              continue
            } else {
              self.scrollTo(block: block, upwards: true)
              break
            }
          }
          else {
            self.scrollTo(block: block, upwards: true)
          }
        }
      }
      else {
        self.scrollTo(block: previousBlock, upwards: true)
      }
    }
    
  }
  
  func checkIfNextBlockShouldBeActivated() {
//    print("Scrolling Downwards!")
    
    guard blocks.count > 0 else { return }
    
    if activeBlock == nil {
      activeBlock = blocks[0]
    }
    
    guard let activeBlock = activeBlock, let blockIndex = blocks.firstIndex(of: activeBlock) else { return }
    
    let nextBlockIndex: Int
    
    if blockIndex == blocks.count - 1 {
      nextBlockIndex = blockIndex
    } else {
      nextBlockIndex = blockIndex + 1
    }
    
    let nextBlock = blocks[nextBlockIndex]
    
//    print("Non Activated Offset: \(nonActivatedOffset)")
//    print("ActiveBlock: \(activeBlock)")
//    print("ScrollViewOffset: \(scrollViewOffset.y)")
    
    if nonActivatedOffset > 0 {
      if nonActivatedOffset > activeBlock.height {
        let filteredBlocks = Array(blocks.suffix(from: nextBlockIndex))
        for (index, block) in filteredBlocks.enumerated() {
          if index != filteredBlocks.count - 1 {
            let nextBlock = filteredBlocks[index + 1]
            
            if nonActivatedOffset > (nextBlock.height / 4) {
              self.activatedOffset += block.height
              continue
            } else {
              self.scrollTo(block: block)
              break
            }
          } else {
            self.scrollTo(block: block)
          }
        }
      }
      else {
        self.scrollTo(block: nextBlock)
      }
    }
  }
}
