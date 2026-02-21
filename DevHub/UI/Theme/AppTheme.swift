//
//  AppTheme.swift
//  DevHub
//
//  Created on 2/21/26.
//

import SwiftUI

enum AppTheme {
    
    // MARK: - Colors
    
    enum Colors {
        static let primary = Color("PrimaryColor") // Botões principais, destaques
        static let secondary = Color("SecondaryColor") // Elementos complementares
        static let background = Color("BackgroundColor") // Fundo de telas
        static let cardBackground = Color("CardBackground") // Fundo de cards
        
        // MARK: System Colors
        enum System {
            static let label = Color.primary
            static let secondaryLabel = Color.secondary
            static let tertiaryLabel = Color(uiColor: .tertiaryLabel)
            static let separator = Color(uiColor: .separator)
        }
    }
    
    // MARK: - Typography
    
    enum Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.medium)
        static let headline = Font.headline
        static let body = Font.body
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
    
    // MARK: - Spacing
    
    enum Spacing {
        static let xxxSmall: CGFloat = 4
        static let xxSmall: CGFloat = 8
        static let xSmall: CGFloat = 12
        static let small: CGFloat = 16
        static let medium: CGFloat = 20
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
        static let xxLarge: CGFloat = 40
        static let xxxLarge: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    
    enum CornerRadius {
        static let none: CGFloat = 0
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 20
        static let circular: CGFloat = .infinity
    }
    
    // MARK: - Elevation (Shadows)
    
    enum Elevation {
        static let low = Shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        static let high = Shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 8)
        
        struct Shadow {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
    }
    
    // MARK: - Animation
    
    enum Animation {
        static let fast = SwiftUI.Animation.easeInOut(duration: 0.15)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.25)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.35)
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
}

// MARK: - View Extensions

extension View {
    func elevation(_ elevation: AppTheme.Elevation.Shadow) -> some View {
        self.shadow(
            color: elevation.color,
            radius: elevation.radius,
            x: elevation.x,
            y: elevation.y
        )
    }
    
    func themedCornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
    
    func cardStyle(
        cornerRadius: CGFloat = AppTheme.CornerRadius.medium,
        elevation: AppTheme.Elevation.Shadow = AppTheme.Elevation.medium
    ) -> some View {
        self
            .background(AppTheme.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .elevation(elevation)
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    ThemePreviewContent()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ThemePreviewContent()
        .preferredColorScheme(.dark)
}

#if DEBUG
struct ThemePreviewContent: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                
                // Colors
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text("Colors")
                        .font(AppTheme.Typography.title)
                    
                    HStack(spacing: AppTheme.Spacing.small) {
                        ColorSwatch(color: AppTheme.Colors.primary, name: "Primary")
                        ColorSwatch(color: AppTheme.Colors.secondary, name: "Secondary")
                        ColorSwatch(color: AppTheme.Colors.cardBackground, name: "Card")
                    }
                }
                
                // Typography
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                    Text("Typography")
                        .font(AppTheme.Typography.title)
                    
                    Text("Large Title").font(AppTheme.Typography.largeTitle)
                    Text("Title").font(AppTheme.Typography.title)
                    Text("Headline").font(AppTheme.Typography.headline)
                    Text("Body").font(AppTheme.Typography.body)
                    Text("Caption").font(AppTheme.Typography.caption)
                }
                
                // Spacing
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text("Spacing")
                        .font(AppTheme.Typography.title)
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                        SpacingBar(width: AppTheme.Spacing.xxxSmall, label: "xxxSmall (4)")
                        SpacingBar(width: AppTheme.Spacing.small, label: "small (16)")
                        SpacingBar(width: AppTheme.Spacing.medium, label: "medium (20)")
                        SpacingBar(width: AppTheme.Spacing.large, label: "large (24)")
                    }
                }
                
                // Corner Radius
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text("Corner Radius")
                        .font(AppTheme.Typography.title)
                    
                    HStack(spacing: AppTheme.Spacing.small) {
                        CornerRadiusExample(radius: AppTheme.CornerRadius.small, label: "Small")
                        CornerRadiusExample(radius: AppTheme.CornerRadius.medium, label: "Medium")
                        CornerRadiusExample(radius: AppTheme.CornerRadius.large, label: "Large")
                    }
                }
                
                // Card Style
                VStack(spacing: AppTheme.Spacing.medium) {
                    Text("Card Style Example")
                        .font(AppTheme.Typography.title)
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text("Card Title")
                            .font(AppTheme.Typography.headline)
                        Text("This is an example card using the themed card style.")
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.System.secondaryLabel)
                    }
                    .padding(AppTheme.Spacing.medium)
                    .cardStyle()
                }
            }
            .padding(AppTheme.Spacing.medium)
        }
        .background(AppTheme.Colors.background)
    }
    
    struct ColorSwatch: View {
        let color: Color
        let name: String
        
        var body: some View {
            VStack(spacing: AppTheme.Spacing.xxxSmall) {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                    .fill(color)
                    .frame(width: 60, height: 60)
                Text(name)
                    .font(AppTheme.Typography.caption)
            }
        }
    }
    
    struct SpacingBar: View {
        let width: CGFloat
        let label: String
        
        var body: some View {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                Rectangle()
                    .fill(AppTheme.Colors.primary)
                    .frame(width: width, height: 20)
                Text(label)
                    .font(AppTheme.Typography.caption)
            }
        }
    }
    
    struct CornerRadiusExample: View {
        let radius: CGFloat
        let label: String
        
        var body: some View {
            VStack(spacing: AppTheme.Spacing.xxxSmall) {
                RoundedRectangle(cornerRadius: radius)
                    .fill(AppTheme.Colors.primary)
                    .frame(width: 60, height: 60)
                Text(label)
                    .font(AppTheme.Typography.caption)
            }
        }
    }
}
#endif
