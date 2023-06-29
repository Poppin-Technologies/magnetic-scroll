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
  
  // MARK: - Views
  private var content: Content
  
  public var body: some View {
    GeometryReader { proxy in
      OffsetObservingScrollView(offset: $organizer.scrollViewOffset) {
        // TODO: Implement block display
        VStack(spacing: organizer.spacing) {
          content
        }
      }
    }
    .environmentObject(organizer)
  }
  
  // MARK: - Initalizers
  
  public init(spacing: CGFloat, @ViewBuilder body: @escaping () -> Content) {
    self.content = body()
    self.spacing = spacing
    
    self._organizer = StateObject(wrappedValue: Organizer(spacing: spacing))
  }
}
