import SwiftUI

extension AccentTint {
    var color: Color {
        switch self {
        case .red:
            return Color(red: 0.93, green: 0.12, blue: 0.15)
        case .orange:
            return Color(red: 0.82, green: 0.53, blue: 0.08)
        case .green:
            return Color(red: 0.12, green: 0.52, blue: 0.39)
        case .blue:
            return Color(red: 0.10, green: 0.38, blue: 0.62)
        case .purple:
            return Color(red: 0.48, green: 0.30, blue: 0.70)
        case .teal:
            return Color(red: 0.08, green: 0.54, blue: 0.58)
        case .gray:
            return .gray
        }
    }

    var audioColor: Color {
        switch self {
        case .red, .blue, .purple:
            return Color(red: 0.93, green: 0.12, blue: 0.15)
        case .orange, .green, .teal:
            return Color(red: 0.82, green: 0.53, blue: 0.08)
        case .gray:
            return Color(red: 0.42, green: 0.42, blue: 0.42)
        }
    }
}

struct NativeGlass: ViewModifier {
    let cornerRadius: CGFloat
    var tint: Color = .white
    var interactive = false

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            if interactive {
                content
                    .glassEffect(.regular.tint(tint.opacity(0.28)).interactive(), in: .rect(cornerRadius: cornerRadius))
            } else {
                content
                    .glassEffect(.regular.tint(tint.opacity(0.22)), in: .rect(cornerRadius: cornerRadius))
            }
        } else {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(.white.opacity(0.52), lineWidth: 0.8)
                }
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
        }
    }
}

extension View {
    func nativeGlass(cornerRadius: CGFloat, tint: Color = .white, interactive: Bool = false) -> some View {
        modifier(NativeGlass(cornerRadius: cornerRadius, tint: tint, interactive: interactive))
    }
}

enum PhrasePageStyle {
    static let pageBackground = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let heroImageName = "HeroVietnamMasthead"
    static let heroImageHeight: CGFloat = 276
    static let heroTextTopPadding: CGFloat = 28
    static let heroTextBottomPadding: CGFloat = 12
    static let heroPlayerTopSpacing: CGFloat = 18
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 28
    static let headerToContentSpacing: CGFloat = 12
    static let headerToLeadInSpacing: CGFloat = 8
    static let leadInToContentSpacing: CGFloat = 16
    static let listCardCornerRadius: CGFloat = 22
    static let compactCardCornerRadius: CGFloat = 20
    static let cardFillOpacity = 0.72
    static let cardStrokeOpacity = 0.06
}

private struct PhraseListCard: ViewModifier {
    let cornerRadius: CGFloat
    let strokeOpacity: Double

    func body(content: Content) -> some View {
        content
            .background(.white.opacity(PhrasePageStyle.cardFillOpacity), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.black.opacity(strokeOpacity), lineWidth: 1)
            }
    }
}

extension View {
    func phraseListCard(
        cornerRadius: CGFloat = PhrasePageStyle.listCardCornerRadius,
        strokeOpacity: Double = PhrasePageStyle.cardStrokeOpacity
    ) -> some View {
        modifier(PhraseListCard(cornerRadius: cornerRadius, strokeOpacity: strokeOpacity))
    }
}

struct HeroMastheadImage: View {
    var body: some View {
        GeometryReader { proxy in
            Image(PhrasePageStyle.heroImageName)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: PhrasePageStyle.heroImageHeight, alignment: .top)
                .offset(y: -72)
                .clipped()
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            .clear,
                            PhrasePageStyle.pageBackground.opacity(0.72),
                            PhrasePageStyle.pageBackground,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 42)
                }
        }
        .frame(height: PhrasePageStyle.heroImageHeight)
    }
}
