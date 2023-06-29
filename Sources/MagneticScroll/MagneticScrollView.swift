//
//  MagneticScrollView.swift
//  
//
//  Created by Ben Myers on 6/27/23.
//

import SwiftUI

@available(iOS 14.0, *)
public struct MagneticScrollView<Content>: View where Content: View {
  @StateObject private var organizer = Organizer()
  
  // MARK: - Views
  private var content: Content
  
  public var body: some View {
    GeometryReader { proxy in
      ScrollView {
        // TODO: Implement block display
        VStack {
          content
        }
      }
    }
    .environmentObject(organizer)
  }
  
  // MARK: - Initalizers
  
  public init(@ViewBuilder body: @escaping () -> Content) {
    self.content = body()
  }
}
