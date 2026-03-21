//
//  PreviewHelper.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import SwiftUI

#if DEBUG

// MARK: - Preview Extensions

extension View {
    func withAuth() -> some View {
        self.environmentObject(AuthService.mock())
    }
}

#endif
