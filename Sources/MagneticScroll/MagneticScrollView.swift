//
//  MagneticScrollView.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI
import SwiftUIIntrospect

@available(iOS 14.0, *)
public struct MagneticScrollView<Content>: View where Content: View {
  @StateObject private var organizer : Organizer
  
  // MARK: - Properties
  var spacing: CGFloat = 8
  
  @Binding var activeBlock: Block.ID
  
  // MARK: - Views
  private var content: Content
  
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
        .onChange(of: organizer.activeBlock) { newValue in
          if activeBlock != organizer.activeBlock?.id {
            activeBlock = newValue
          }
        }
      }
    }
    .environmentObject(organizer)
  }
  
  // MARK: - Initalizers
  
  public init(spacing: CGFloat = 10, activeBlock: Binding<Block.ID>, @ViewBuilder body: @escaping () -> Content) {
    self.content = body()
    self.spacing = spacing
    
    // Initialize Bindings
    self._activeBlock = activeBlock
    self._organizer = StateObject(wrappedValue: Organizer(spacing: spacing))
  }
}
