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
        case .red, .orange, .green, .blue, .purple, .teal:
            return Color(red: 0.93, green: 0.12, blue: 0.15)
        case .gray:
            return Color(red: 0.42, green: 0.42, blue: 0.42)
        }
    }
}

struct NativeGlass<S: Shape>: ViewModifier {
    let shape: S
    var tint: Color = .white
    var interactive = false

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *), interactive {
            content
                .glassEffect(.regular.tint(tint.opacity(0.44)).interactive(), in: shape)
        } else {
            content
                .background(.ultraThinMaterial, in: shape)
                .overlay {
                    shape
                        .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 0.8)
                }
                .shadow(
                    color: .black.opacity(AppSurfaceDepth.cardOpacity),
                    radius: AppSurfaceDepth.cardRadius,
                    x: 0,
                    y: AppSurfaceDepth.cardYOffset
                )
        }
    }
}

extension View {
    func nativeGlass(cornerRadius: CGFloat, tint: Color = .white, interactive: Bool = false) -> some View {
        nativeGlass(
            in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            tint: tint,
            interactive: interactive
        )
    }

    func nativeGlass<S: Shape>(in shape: S, tint: Color = .white, interactive: Bool = false) -> some View {
        modifier(NativeGlass(shape: shape, tint: tint, interactive: interactive))
    }

}

enum HomePhraseHeroMorphID {
    static func card(_ pageID: String) -> String {
        "home.phrase.hero.card.\(pageID)"
    }

    static func title(_ pageID: String) -> String {
        "home.phrase.hero.title.\(pageID)"
    }

    static func copyStack(_ pageID: String) -> String {
        "home.phrase.hero.copy.\(pageID)"
    }

    static func english(_ pageID: String) -> String {
        "home.phrase.hero.english.\(pageID)"
    }

    static func pronunciation(_ pageID: String) -> String {
        "home.phrase.hero.pronunciation.\(pageID)"
    }

    static func player(_ pageID: String) -> String {
        "home.phrase.hero.player.\(pageID)"
    }
}

extension View {
    @ViewBuilder
    func homePhraseHeroMorph(
        _ id: String,
        namespace: Namespace.ID?,
        isActive: Bool,
        isSource: Bool,
        properties: MatchedGeometryProperties = .frame,
        anchor: UnitPoint = .center
    ) -> some View {
        if isActive, let namespace {
            matchedGeometryEffect(
                id: id,
                in: namespace,
                properties: properties,
                anchor: anchor,
                isSource: isSource
            )
        } else {
            self
        }
    }
}

struct PhraseHeroCopyStack: View {
    let title: String
    let englishTitle: String
    let pronunciation: String
    var titleSize: CGFloat
    var titleLineLimit = 2
    var pronunciationLineLimit = 2
    var morphPageID: String? = nil
    var morphNamespace: Namespace.ID? = nil
    var isMorphActive = false
    var isMorphSource = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: titleSize, weight: .black, design: .serif))
                .foregroundStyle(.primary)
                .lineLimit(titleLineLimit)
                .minimumScaleFactor(0.62)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(englishTitle)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.78)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !pronunciation.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "waveform")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.red)
                        .frame(width: 26)

                    Text(pronunciation)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .lineLimit(pronunciationLineLimit)
                        .minimumScaleFactor(0.72)
                }
                .padding(.top, 2)
            }
        }
        .homePhraseHeroMorph(
            morphID,
            namespace: morphNamespace,
            isActive: isMorphActive && morphPageID != nil,
            isSource: isMorphSource,
            anchor: .topLeading
        )
    }

    private var morphID: String {
        guard let morphPageID else {
            return ""
        }
        return HomePhraseHeroMorphID.copyStack(morphPageID)
    }
}

enum PhrasePageStyle {
    static let pageBackground = Color(.systemBackground)
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
    static let articleSectionsTopPadding: CGFloat = 28
    static let listCardCornerRadius: CGFloat = 22
    static let compactCardCornerRadius: CGFloat = 20
    static let bottomChromeContentClearance: CGFloat = 116
    static let cardShadowBleedPadding: CGFloat = 24
    static let cardFillOpacity = 0.98
    static let cardStrokeOpacity = 0.035
    static let cardEdgeStrokeOpacity = 0.72

    static var cardFill: Color {
        Color(.systemBackground).opacity(cardFillOpacity)
    }

    static var elevatedCardFill: Color {
        Color(.systemBackground).opacity(0.98)
    }

    static var glassCardFill: Color {
        Color(.systemBackground).opacity(0.62)
    }

    static var imageCaptionFill: Color {
        Color(.systemBackground).opacity(0.98)
    }
}

enum AppSurfaceDepth {
    static let cardOpacity = 0.045
    static let cardRadius: CGFloat = 14
    static let cardYOffset: CGFloat = 6
    static let imageCardOpacity = cardOpacity
    static let controlOpacity = 0.045
    static let controlRadius: CGFloat = 14
    static let controlYOffset: CGFloat = 6
    static let controlStrokeOpacity = 0.72
    static let controlDividerOpacity = 0.08
    static let sheetOpacity = 0.06
    static let sheetRadius: CGFloat = 36
    static let sheetYOffset: CGFloat = -14
}

extension View {
    func softAmbientCardShadow(
        opacity: Double = AppSurfaceDepth.cardOpacity,
        radius: CGFloat = AppSurfaceDepth.cardRadius,
        y: CGFloat = AppSurfaceDepth.cardYOffset
    ) -> some View {
        shadow(color: .black.opacity(opacity), radius: radius, x: 0, y: y)
    }

    func softLiftedSheetShadow() -> some View {
        shadow(
            color: .black.opacity(AppSurfaceDepth.sheetOpacity),
            radius: AppSurfaceDepth.sheetRadius,
            x: 0,
            y: AppSurfaceDepth.sheetYOffset
        )
    }

    func softInteractiveControlShadow() -> some View {
        shadow(
            color: .black.opacity(AppSurfaceDepth.controlOpacity),
            radius: AppSurfaceDepth.controlRadius,
            x: 0,
            y: AppSurfaceDepth.controlYOffset
        )
    }
}

enum AppChromeLayout {
    static let topSeparationHeight: CGFloat = 112
    static let chromeSeparationAllowsHitTesting = false
    static let searchMorphDuration = 0.39
    static let searchForegroundMorphZIndex: Double = 6
    static let contentPageLayerZIndex: Double = 0
    static let searchPageLayerZIndex: Double = 200
    static let chromeSeparationLayerZIndex: Double = 360
    static let topAdminHitTestLayerZIndex: Double = 390
    static let topAdminControlLayerZIndex: Double = 410
    static let bottomAdminHitTestLayerZIndex: Double = 430
    static let topAdminHorizontalPadding: CGFloat = 24
    static let topAdminTopPadding: CGFloat = 10
    static let topAdminControlSize: CGFloat = 47
    static let topAdminControlCornerRadius: CGFloat = topAdminControlSize / 2
    static let menuSectionChromeHeight: CGFloat = 38
    static let menuSectionChromeRowSpacing: CGFloat = 8
    static let menuSectionBackdropTopOffset: CGFloat = topAdminTopPadding + topAdminControlSize + menuSectionChromeRowSpacing
    static let menuSectionBackdropHeight: CGFloat = 92
    static let menuSectionJumpClearance: CGFloat = topAdminTopPadding + topAdminControlSize + menuSectionChromeRowSpacing + menuSectionChromeHeight + 44
    static let menuSectionJumpViewportAnchorY: CGFloat = 0.19
    static let pinnedAudioSpeedRevealY: CGFloat = 96
    static let pinnedAudioSpeedScrollClearance: CGFloat = 0
    static let topAdminHitTestEnvelopeHeight: CGFloat = 132
    static let pinnedAudioSpeedBackdropHeight: CGFloat = topSeparationHeight
    static let bottomAdminHitTestEnvelopeHeight: CGFloat = 92

    static func topChromeBackdropHeight(showsMenuSectionChrome: Bool) -> CGFloat {
        if showsMenuSectionChrome {
            return max(topSeparationHeight, menuSectionBackdropTopOffset + menuSectionBackdropHeight)
        }

        return topSeparationHeight
    }
}

enum ChromeSeparationEdge {
    case top
}

enum ChromeSeparationGradientStyle: Equatable {
    case light
    case darkPhoto
}

struct ChromeSeparationGradient: View {
    let edge: ChromeSeparationEdge
    var extendsBehindMenuSectionChrome = false
    var style: ChromeSeparationGradientStyle = .light

    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: gradientStops),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: AppChromeLayout.topChromeBackdropHeight(showsMenuSectionChrome: extendsBehindMenuSectionChrome))
        .ignoresSafeArea(edges: .top)
        .allowsHitTesting(AppChromeLayout.chromeSeparationAllowsHitTesting)
    }

    private var gradientStops: [Gradient.Stop] {
        if style == .darkPhoto {
            return [
                .init(color: Color.black.opacity(0.68), location: 0),
                .init(color: Color.black.opacity(0.48), location: 0.34),
                .init(color: Color.black.opacity(0.18), location: 0.72),
                .init(color: Color.black.opacity(0), location: 1),
            ]
        }

        guard extendsBehindMenuSectionChrome else {
            return [
                .init(color: Color(.systemBackground).opacity(0.96), location: 0),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.48), location: 0.42),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.12), location: 0.76),
                .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 1),
            ]
        }

        return [
            .init(color: Color(.systemBackground).opacity(0.97), location: 0),
            .init(color: Color(.systemBackground).opacity(0.95), location: 0.24),
            .init(color: Color(.systemBackground).opacity(0.84), location: 0.52),
            .init(color: PhrasePageStyle.pageBackground.opacity(0.30), location: 0.78),
            .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 1),
        ]
    }
}

struct TopAdminHitTestEnvelope: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(maxWidth: .infinity)
            .frame(height: AppChromeLayout.topAdminHitTestEnvelopeHeight)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

enum SearchPageLayout {
    static let horizontalPadding: CGFloat = 24
    static let titleTopPadding: CGFloat = 74
    static let focusedResultsTopPadding: CGFloat = 116
    static let contentSpacing: CGFloat = 20
    static let resultGroupSpacing: CGFloat = 12
    static let resultGroupTopPadding: CGFloat = 10
    static let resultsBottomClearance: CGFloat = PhrasePageStyle.bottomChromeContentClearance
    static let resultsZIndex: Double = 0

    static func headerMode(query: String, isFieldFocused _: Bool) -> SearchPageHeaderMode {
        query.isEmpty ? .full : .compactResults
    }
}

enum SearchPageHeaderMode: Equatable {
    case full
    case compactResults

    var showsMasthead: Bool {
        self == .full
    }

    var showsSubtitle: Bool {
        self == .full
    }

    var brandTopPadding: CGFloat {
        switch self {
        case .full:
            return 14
        case .compactResults:
            return 0
        }
    }

    var titleSize: CGFloat {
        switch self {
        case .full:
            return 42
        case .compactResults:
            return 34
        }
    }

    var titleTopPadding: CGFloat {
        switch self {
        case .full:
            return 14
        case .compactResults:
            return 8
        }
    }

    func contentTopPadding(topMastheadBleed: CGFloat) -> CGFloat {
        switch self {
        case .full:
            return -topMastheadBleed
        case .compactResults:
            return SearchPageLayout.focusedResultsTopPadding
        }
    }
}

private struct PhraseListCard: ViewModifier {
    let cornerRadius: CGFloat
    let edgeStrokeOpacity: Double

    func body(content: Content) -> some View {
        content
            .background(PhrasePageStyle.cardFill, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(edgeStrokeOpacity), lineWidth: 1)
                    .allowsHitTesting(false)
            }
            .softAmbientCardShadow()
    }
}

extension View {
    func phraseListCard(
        cornerRadius: CGFloat = PhrasePageStyle.listCardCornerRadius,
        edgeStrokeOpacity: Double = PhrasePageStyle.cardEdgeStrokeOpacity
    ) -> some View {
        modifier(PhraseListCard(cornerRadius: cornerRadius, edgeStrokeOpacity: edgeStrokeOpacity))
    }
}

struct HeroMastheadImage: View {
    var imageName: String = PhrasePageStyle.heroImageName
    var verticalOffset: CGFloat? = nil
    var height: CGFloat = PhrasePageStyle.heroImageHeight

    private var resolvedVerticalOffset: CGFloat {
        verticalOffset ?? Self.defaultVerticalOffset(for: imageName)
    }

    private var imageRenderHeight: CGFloat {
        height + abs(resolvedVerticalOffset) + 72
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                PhrasePageStyle.pageBackground

                ZStack(alignment: .top) {
                    if imageName == "HeroNeutralMasthead" {
                        neutralMasthead(width: proxy.size.width, height: imageRenderHeight)
                    } else {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: imageRenderHeight, alignment: .top)
                            .offset(y: resolvedVerticalOffset)
                    }
                }
                .frame(width: proxy.size.width, height: height, alignment: .top)
                .clipped()
                .mask {
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0),
                            .init(color: .black, location: 0.58),
                            .init(color: .black.opacity(0.88), location: 0.74),
                            .init(color: .black.opacity(0.36), location: 0.92),
                            .init(color: .clear, location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }

                LinearGradient(
                    stops: [
                        .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 0),
                        .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 0.36),
                        .init(color: PhrasePageStyle.pageBackground.opacity(0.12), location: 0.6),
                        .init(color: PhrasePageStyle.pageBackground.opacity(0.58), location: 0.88),
                        .init(color: PhrasePageStyle.pageBackground, location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: height)
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
                .frame(height: 28)
            }
        }
        .frame(height: height)
        .clipped()
    }

    private func neutralMasthead(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color.white, location: 0),
                    .init(color: Color(red: 0.94, green: 0.97, blue: 0.98), location: 0.44),
                    .init(color: PhrasePageStyle.pageBackground, location: 1),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    Color.red.opacity(0.08),
                    Color.clear,
                ],
                startPoint: .topLeading,
                endPoint: .center
            )

            LinearGradient(
                colors: [
                    Color.blue.opacity(0.07),
                    Color.clear,
                ],
                startPoint: .topTrailing,
                endPoint: .center
            )
        }
        .frame(width: width, height: height)
    }

    private static func defaultVerticalOffset(for imageName: String) -> CGFloat {
        switch imageName {
        case "HeroBaNaHills":
            return 0
        case "HeroCityHcmc":
            return -152
        case "HeroCityHanoi", "HeroCityDanang", "HeroCityHoian", "HeroCityHue":
            return -132
        case "HeroCategoryAirport":
            return -126
        case "HeroCategoryFirstDay":
            return -112
        case "HeroCategoryEmergency", "HeroCategoryEssentials":
            return -78
        default:
            if imageName.hasPrefix("HeroCity") && imageName.contains("Place") {
                return -220
            }

            if imageName.hasPrefix("HeroCity")
                || imageName.hasPrefix("HeroCategory")
                || imageName.hasPrefix("HeroCountry")
                || imageName == "HeroCompactPhraseMasthead" {
                return 0
            }

            return PhrasePageStyle.heroImageVerticalOffset
        }
    }
}
