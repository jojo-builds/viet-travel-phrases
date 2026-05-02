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

    @ViewBuilder
    func nativeGlassMorphID(_ id: String, namespace: Namespace.ID?) -> some View {
        if #available(iOS 26.0, *), let namespace {
            glassEffectID(id, in: namespace)
        } else {
            self
        }
    }

    @ViewBuilder
    func chromeMorph(_ id: String, namespace: Namespace.ID?, isSource: Bool) -> some View {
        if let namespace {
            matchedGeometryEffect(
                id: id,
                in: namespace,
                properties: .frame,
                anchor: .center,
                isSource: isSource
            )
        } else {
            self
        }
    }

    @ViewBuilder
    func chromeIconMorph(_ id: String, namespace: Namespace.ID?, isSource: Bool) -> some View {
        if let namespace {
            matchedGeometryEffect(
                id: id,
                in: namespace,
                properties: .position,
                anchor: .center,
                isSource: isSource
            )
        } else {
            self
        }
    }
}

enum AppChromeMorphID {
    static let dock = "app.chrome.dock"
    static let search = "app.chrome.search"

    static func dockItem(_ item: DockItemKind) -> String {
        "app.chrome.dock.\(item.title)"
    }
}

enum PhrasePageStyle {
    static let pageBackground = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let heroImageName = "HeroVietnamMasthead"
    static let heroImageHeight: CGFloat = 276
    static let heroImageVerticalOffset: CGFloat = -112
    static let heroImageFadeHeight: CGFloat = 104
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
    static let bottomChromeContentClearance: CGFloat = 176
    static let cardFillOpacity = 0.72
    static let cardStrokeOpacity = 0.06
}

enum AppChromeLayout {
    static let bottomOuterHorizontalPadding: CGFloat = 16
    static let bottomSpacing: CGFloat = 8
    static let bottomPadding: CGFloat = -10
    static let bottomOffset: CGFloat = 10
    static let bottomSeparationHeight: CGFloat = 240
    static let topSeparationHeight: CGFloat = 170
    static let dockItemSpacing: CGFloat = 12
    static let dockItemWidth: CGFloat = 52
    static let dockItemHeight: CGFloat = 50
    static let dockHorizontalPadding: CGFloat = 12
    static let dockVerticalPadding: CGFloat = 4
    static let dockCornerRadius: CGFloat = 29
    static let searchIslandSize: CGFloat = 58
    static let searchIslandCornerRadius: CGFloat = 29
    static let searchFieldHeight: CGFloat = 58
    static let searchFieldHorizontalPadding: CGFloat = 14
    static let searchMorphDuration = 0.39
}

enum ChromeSeparationEdge {
    case top
    case bottom
}

struct ChromeSeparationGradient: View {
    let edge: ChromeSeparationEdge

    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: gradientStops),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: edge == .bottom ? AppChromeLayout.bottomSeparationHeight : AppChromeLayout.topSeparationHeight)
        .ignoresSafeArea(edges: edge == .bottom ? .bottom : .top)
        .allowsHitTesting(false)
    }

    private var gradientStops: [Gradient.Stop] {
        switch edge {
        case .bottom:
            return [
                .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 0),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.18), location: 0.14),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.64), location: 0.42),
                .init(color: Color(.systemBackground).opacity(0.94), location: 0.72),
                .init(color: Color(.systemBackground), location: 1),
            ]
        case .top:
            return [
                .init(color: Color(.systemBackground).opacity(0.98), location: 0),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.82), location: 0.34),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.28), location: 0.72),
                .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 1),
            ]
        }
    }
}

enum SearchPageLayout {
    static let horizontalPadding: CGFloat = 24
    static let titleTopPadding: CGFloat = 74
    static let contentSpacing: CGFloat = 20
    static let resultGroupSpacing: CGFloat = 12
    static let resultGroupTopPadding: CGFloat = 10
    static let resultsBottomClearance: CGFloat = 148
    static let resultsZIndex: Double = 0
    static let pinnedChromeZIndex: Double = 2
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
    var imageName: String = PhrasePageStyle.heroImageName
    var verticalOffset: CGFloat = PhrasePageStyle.heroImageVerticalOffset

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                PhrasePageStyle.pageBackground

                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: PhrasePageStyle.heroImageHeight, alignment: .top)
                    .offset(y: verticalOffset)
                    .clipped()
                    .mask {
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.74),
                                .init(color: .black.opacity(0.9), location: 0.84),
                                .init(color: .black.opacity(0.34), location: 0.95),
                                .init(color: .clear, location: 1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }

                LinearGradient(
                    stops: [
                        .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 0),
                        .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 0.38),
                        .init(color: PhrasePageStyle.pageBackground.opacity(0.14), location: 0.62),
                        .init(color: PhrasePageStyle.pageBackground.opacity(0.68), location: 0.88),
                        .init(color: PhrasePageStyle.pageBackground, location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: PhrasePageStyle.heroImageFadeHeight)
            }
            .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            .clear,
                            PhrasePageStyle.pageBackground,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 18)
            }
        }
        .frame(height: PhrasePageStyle.heroImageHeight)
        .clipped()
    }
}
