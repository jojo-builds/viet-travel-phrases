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
    static let dockSelection = "app.chrome.dock.selection"
    static let search = "app.chrome.search"
    static let searchIcon = "app.chrome.search.icon"

    static func dockItem(_ item: DockItemKind) -> String {
        "app.chrome.dock.\(item.title)"
    }
}

enum HomePhraseHeroMorphID {
    static func card(_ pageID: String) -> String {
        "home.phrase.hero.card.\(pageID)"
    }

    static func title(_ pageID: String) -> String {
        "home.phrase.hero.title.\(pageID)"
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
    static let bottomChromeContentClearance: CGFloat = 224
    static let cardFillOpacity = 0.72
    static let cardStrokeOpacity = 0.06
}

enum AppChromeLayout {
    static let bottomOuterHorizontalPadding: CGFloat = 16
    static let bottomSpacing: CGFloat = 6
    static let bottomPadding: CGFloat = -10
    static let bottomOffset: CGFloat = 2
    static let bottomSeparationHeight: CGFloat = 0
    static let topSeparationHeight: CGFloat = 112
    static let bottomHitTestEnvelopeHeight: CGFloat = 84
    static let chromeSeparationAllowsHitTesting = false
    static let dockItemSpacing: CGFloat = 10
    static let dockItemWidth: CGFloat = 50
    static let dockItemHeight: CGFloat = 46
    static let dockSelectionWidth: CGFloat = 68
    static let dockSelectionHeight: CGFloat = 46
    static let dockSelectionCornerRadius: CGFloat = 23
    static let dockSelectionMorphDuration = 0.42
    static let dockSelectionDragCommitDistance: CGFloat = 4
    static let dockSelectionStretchFactor: CGFloat = 0.30
    static let dockSelectionMaximumStretch: CGFloat = 54
    static let dockSelectionLagFactor: CGFloat = 0.16
    static let dockSelectionMaximumLag: CGFloat = 14
    static let dockSelectionTapActivationDelay: UInt64 = 45_000_000
    static let dockSelectionTapWaypointDelay: UInt64 = 94_000_000
    static let dockSelectionTapSettleDelay: UInt64 = 120_000_000
    static let dockSelectionTapDeactivateDelay: UInt64 = 90_000_000
    static let dockHorizontalPadding: CGFloat = 10
    static let dockVerticalPadding: CGFloat = 3
    static let dockCornerRadius: CGFloat = 26
    static let searchIslandSize: CGFloat = 52
    static let searchIslandCornerRadius: CGFloat = 26
    static let searchFieldHeight: CGFloat = 52
    static let searchFieldHorizontalPadding: CGFloat = 14
    static let searchMorphDuration = 0.39
    static let dockMorphZIndex: Double = 2
    static let searchMorphZIndex: Double = 3
    static let searchOriginMorphZIndex: Double = 4
    static let keyboardDismissMorphZIndex: Double = 5
    static let searchForegroundMorphZIndex: Double = 6
    static let dockSelectionLensZIndex: Double = 1
    static let dockItemForegroundZIndex: Double = 2
    static let searchFieldIconSlotWidth: CGFloat = 24
    static let topAdminHorizontalPadding: CGFloat = 24
    static let topAdminTopPadding: CGFloat = 10
    static let topAdminControlSize: CGFloat = 47
    static let topAdminControlCornerRadius: CGFloat = topAdminControlSize / 2
    static let pinnedAudioSpeedRevealY: CGFloat = 96
    static let pinnedAudioSpeedScrollClearance: CGFloat = 0
    static let topAdminHitTestEnvelopeHeight: CGFloat = 132
    static let pinnedAudioSpeedBackdropHeight: CGFloat = topSeparationHeight
}

struct AppDockSelectionLensMetrics: Equatable {
    let xOffset: CGFloat
    let width: CGFloat
}

enum AppDockSelectionLayout {
    static func contentWidth(itemCount: Int) -> CGFloat {
        guard itemCount > 0 else {
            return 0
        }

        return CGFloat(itemCount) * AppChromeLayout.dockItemWidth
            + CGFloat(itemCount - 1) * AppChromeLayout.dockItemSpacing
    }

    static func itemIndex(for locationX: CGFloat, itemCount: Int) -> Int? {
        itemIndex(for: locationX, itemCount: itemCount, contentWidth: contentWidth(itemCount: itemCount))
    }

    static func itemIndex(for locationX: CGFloat, itemCount: Int, contentWidth: CGFloat) -> Int? {
        guard itemCount > 0 else {
            return nil
        }

        let trackWidth = max(contentWidth, self.contentWidth(itemCount: itemCount))
        guard itemCount > 1 else {
            return 0
        }

        let leadingCenter = AppChromeLayout.dockItemWidth / 2
        let trailingCenter = trackWidth - AppChromeLayout.dockItemWidth / 2
        let pitch = (trailingCenter - leadingCenter) / CGFloat(itemCount - 1)
        let clampedX = min(max(locationX, 0), trackWidth)
        let rawIndex = ((clampedX - leadingCenter) / pitch).rounded()
        return min(max(Int(rawIndex), 0), itemCount - 1)
    }

    static func clampedDragX(_ locationX: CGFloat, itemCount: Int) -> CGFloat {
        clampedDragX(locationX, itemCount: itemCount, contentWidth: contentWidth(itemCount: itemCount))
    }

    static func clampedDragX(_ locationX: CGFloat, itemCount: Int, contentWidth: CGFloat) -> CGFloat {
        let trackWidth = max(contentWidth, self.contentWidth(itemCount: itemCount))
        return min(max(locationX, AppChromeLayout.dockItemWidth / 2), trackWidth - AppChromeLayout.dockItemWidth / 2)
    }

    static func itemCenterX(index: Int) -> CGFloat {
        CGFloat(index) * (AppChromeLayout.dockItemWidth + AppChromeLayout.dockItemSpacing)
            + AppChromeLayout.dockItemWidth / 2
    }

    static func itemCenterX(index: Int, itemCount: Int, contentWidth: CGFloat) -> CGFloat {
        guard itemCount > 0 else {
            return 0
        }

        guard itemCount > 1 else {
            return max(contentWidth, AppChromeLayout.dockItemWidth) / 2
        }

        let trackWidth = max(contentWidth, self.contentWidth(itemCount: itemCount))
        let leadingCenter = AppChromeLayout.dockItemWidth / 2
        let trailingCenter = trackWidth - AppChromeLayout.dockItemWidth / 2
        let pitch = (trailingCenter - leadingCenter) / CGFloat(itemCount - 1)
        return leadingCenter + CGFloat(min(max(index, 0), itemCount - 1)) * pitch
    }

    static func waypointIndexes(from sourceIndex: Int, to destinationIndex: Int) -> [Int] {
        guard sourceIndex != destinationIndex else {
            return [destinationIndex]
        }

        let step = destinationIndex > sourceIndex ? 1 : -1
        return Array(stride(from: sourceIndex + step, through: destinationIndex, by: step))
    }

    static func lensMetrics(
        selectedIndex: Int,
        activeIndex: Int?,
        dragX: CGFloat?,
        itemCount: Int,
        reduceMotion: Bool,
        contentWidth: CGFloat? = nil
    ) -> AppDockSelectionLensMetrics {
        let trackWidth = contentWidth ?? self.contentWidth(itemCount: itemCount)
        let selectedCenter = itemCenterX(index: selectedIndex, itemCount: itemCount, contentWidth: trackWidth)
        let fallbackCenter = activeIndex.map {
            itemCenterX(index: $0, itemCount: itemCount, contentWidth: trackWidth)
        } ?? selectedCenter
        let targetCenter = dragX.map { clampedDragX($0, itemCount: itemCount, contentWidth: trackWidth) } ?? fallbackCenter

        guard !reduceMotion, dragX != nil else {
            return AppDockSelectionLensMetrics(
                xOffset: fallbackCenter - AppChromeLayout.dockSelectionWidth / 2,
                width: AppChromeLayout.dockSelectionWidth
            )
        }

        let distance = abs(targetCenter - selectedCenter)
        let stretch = min(distance * AppChromeLayout.dockSelectionStretchFactor, AppChromeLayout.dockSelectionMaximumStretch)
        let lag = min(distance * AppChromeLayout.dockSelectionLagFactor, AppChromeLayout.dockSelectionMaximumLag)
        let direction: CGFloat = targetCenter >= selectedCenter ? 1 : -1
        let liquidCenter = targetCenter - direction * lag
        let width = AppChromeLayout.dockSelectionWidth + stretch

        return AppDockSelectionLensMetrics(
            xOffset: liquidCenter - width / 2,
            width: width
        )
    }
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
        .allowsHitTesting(AppChromeLayout.chromeSeparationAllowsHitTesting)
    }

    private var gradientStops: [Gradient.Stop] {
        switch edge {
        case .bottom:
            return [
                .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 0),
                .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 0.34),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.14), location: 0.60),
                .init(color: Color(.systemBackground).opacity(0.38), location: 0.82),
                .init(color: Color(.systemBackground).opacity(0.66), location: 1),
            ]
        case .top:
            return [
                .init(color: Color(.systemBackground).opacity(0.96), location: 0),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.48), location: 0.42),
                .init(color: PhrasePageStyle.pageBackground.opacity(0.12), location: 0.76),
                .init(color: PhrasePageStyle.pageBackground.opacity(0), location: 1),
            ]
        }
    }
}

struct TopAdminHitTestEnvelope: View {
    var body: some View {
        Rectangle()
            .fill(Color(.systemBackground).opacity(0.001))
            .frame(maxWidth: .infinity)
            .frame(height: AppChromeLayout.topAdminHitTestEnvelopeHeight)
            .contentShape(Rectangle())
            .onTapGesture {}
            .accessibilityHidden(true)
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
                    .allowsHitTesting(false)
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
    var verticalOffset: CGFloat? = nil

    private var resolvedVerticalOffset: CGFloat {
        verticalOffset ?? Self.defaultVerticalOffset(for: imageName)
    }

    private var imageRenderHeight: CGFloat {
        PhrasePageStyle.heroImageHeight + abs(resolvedVerticalOffset) + 72
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
                .frame(width: proxy.size.width, height: PhrasePageStyle.heroImageHeight, alignment: .top)
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
                .frame(height: PhrasePageStyle.heroImageHeight)
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
        .frame(height: PhrasePageStyle.heroImageHeight)
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
        default:
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
