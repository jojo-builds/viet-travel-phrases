import SwiftUI

struct VietnameseMenuPageView: View {
    let kind: VietnameseMenuKind
    let scrollToTopTrigger: Int
    let scrollToTopRoute: BrowseCollectionRoute?
    let sectionJumpRequest: VietnameseMenuSectionJumpRequest?
    var onOpenDetail: (String) -> Void

    @State private var currentSectionID: String?
    @State private var isSectionRailPinned = false
    @State private var pendingSectionJumpID = 0
    @State private var pendingSectionJumpSectionID: String?

    private var route: BrowseCollectionRoute {
        .category(kind.routeID)
    }

    private var sections: [VietnameseMenuSection] {
        VietnameseMenuCatalog.sections(for: kind)
    }

    private var resolvedCurrentSectionID: String {
        currentSectionID ?? sections.first?.id ?? "popular"
    }

    private var sectionChromeState: VietnameseMenuSectionChromeState? {
        guard !sections.isEmpty else {
            return nil
        }

        return VietnameseMenuSectionChromeState(
            route: route,
            currentSectionID: resolvedCurrentSectionID,
            isPinned: isSectionRailPinned,
            sections: sections.map { section in
                VietnameseMenuSectionChromeItem(
                    id: section.id,
                    title: section.title,
                    symbolName: section.symbolName,
                    tintName: section.tintName
                )
            }
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: VietnameseMenuLayout.sectionSpacing) {
                        header
                            .id(Self.scrollTopID)

                        sectionRail(scrollProxy: scrollProxy)

                        sectionedMenu
                            .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)
                    }
                    .padding(.bottom, VietnameseMenuLayout.bottomChromeContentClearance)
                }
                .onPreferenceChange(VietnameseMenuSectionFramePreferenceKey.self) { frames in
                    updateCurrentSection(from: frames)
                }
                .onPreferenceChange(VietnameseMenuRailFramePreferenceKey.self) { frame in
                    isSectionRailPinned = (frame?.maxY ?? .greatestFiniteMagnitude) <= VietnameseMenuLayout.glassRailRevealY
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    guard scrollToTopRoute == nil || scrollToTopRoute == route else {
                        return
                    }

                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
                .onChange(of: sectionJumpRequest?.requestID) { _, _ in
                    guard let sectionJumpRequest, sectionJumpRequest.route == route else {
                        return
                    }

                    jumpToSection(sectionJumpRequest.sectionID)
                }
                .task(id: pendingSectionJumpID) {
                    await performPendingSectionJump(scrollProxy)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .preference(
            key: VietnameseMenuSectionChromePreferenceKey.self,
            value: sectionChromeState.map { [$0] } ?? []
        )
        .accessibilityIdentifier("VietnameseMenu.\(kind.routeID)")
    }

    private static let scrollTopID = "VietnameseMenuPageTop"

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage(imageName: kind.heroImageName, height: VietnameseMenuLayout.heroHeight)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle().fill(Color.red)
                        Image(systemName: "star.fill")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.yellow)
                    }
                    .frame(width: 22, height: 22)

                    Text("SPEAKLOCAL VIETNAM")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text(kind.title)
                    .font(.system(size: 46, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)
                    .accessibilityIdentifier("VietnameseMenu.Title.\(kind.routeID)")

                Text(kind.subtitle)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)
            .padding(.top, 16)
        }
    }

    private func sectionRail(scrollProxy: ScrollViewProxy) -> some View {
        GeometryReader { proxy in
            let cardWidth = VietnameseMenuLayout.sectionCardWidth(containerWidth: proxy.size.width)

            ScrollViewReader { railProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: VietnameseMenuLayout.sectionCardSpacing) {
                        ForEach(sections) { section in
                            VietnameseMenuSectionImageCard(
                                accessibilityID: section.id,
                                title: section.title,
                                imageName: section.featuredImageName,
                                tintName: section.tintName,
                                isSelected: resolvedCurrentSectionID == section.id,
                                action: { jumpToSection(section.id) }
                            )
                            .frame(width: cardWidth)
                            .id(Self.railScrollID(for: section.id))
                        }
                    }
                    .padding(.leading, VietnameseMenuLayout.horizontalPadding)
                    .padding(.trailing, VietnameseMenuLayout.horizontalPadding)
                    .padding(.bottom, 2)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
                .onChange(of: resolvedCurrentSectionID) { _, sectionID in
                    withAnimation(.snappy(duration: 0.24)) {
                        railProxy.scrollTo(Self.railScrollID(for: sectionID), anchor: .leading)
                    }
                }
            }
        }
        .frame(height: VietnameseMenuLayout.sectionCardHeight)
        .background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: VietnameseMenuRailFramePreferenceKey.self,
                    value: proxy.frame(in: .global)
                )
            }
        }
    }

    private var sectionedMenu: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                Color.clear
                    .frame(width: 1, height: 1)
                    .id(Self.sectionAnchorID(for: section.id))
                    .accessibilityHidden(true)

                VietnameseMenuSectionBlock(
                    section: section,
                    heroImageName: menuThumbnailImageName,
                    onOpenDetail: onOpenDetail
                )
                .padding(.top, index == 0 ? 0 : VietnameseMenuLayout.sectionSpacing)
                .background {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: VietnameseMenuSectionFramePreferenceKey.self,
                            value: [
                                VietnameseMenuSectionFrame(
                                    id: section.id,
                                    order: index,
                                    minY: proxy.frame(in: .global).minY
                                ),
                            ]
                        )
                    }
                }
            }
        }
    }

    private func jumpToSection(_ sectionID: String) {
        guard sections.contains(where: { $0.id == sectionID }) else {
            return
        }

        currentSectionID = sectionID
        pendingSectionJumpSectionID = sectionID
        pendingSectionJumpID += 1
    }

    @MainActor
    private func performPendingSectionJump(_ scrollProxy: ScrollViewProxy) async {
        guard pendingSectionJumpID > 0, let pendingSectionJumpSectionID else {
            return
        }

        try? await Task.sleep(nanoseconds: VietnameseMenuLayout.sectionJumpDelayNanoseconds)
        guard !Task.isCancelled else {
            return
        }

        withAnimation(.snappy(duration: 0.32)) {
            scrollProxy.scrollTo(
                Self.sectionAnchorID(for: pendingSectionJumpSectionID),
                anchor: UnitPoint(x: 0.5, y: VietnameseMenuLayout.sectionJumpViewportAnchorY)
            )
        }
    }

    private static func railScrollID(for sectionID: String) -> String {
        "rail-\(sectionID)"
    }

    private static func sectionAnchorID(for sectionID: String) -> String {
        "section-anchor-\(sectionID)"
    }

    private func updateCurrentSection(from frames: [VietnameseMenuSectionFrame]) {
        guard !frames.isEmpty else {
            return
        }

        let sortedFrames = frames.sorted { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.minY < rhs.minY
            }

            return lhs.order < rhs.order
        }
        let activeFrames = sortedFrames.filter { $0.minY <= VietnameseMenuLayout.sectionActivationY }
        let selectedFrame = activeFrames.max { $0.minY < $1.minY } ?? sortedFrames.first

        if currentSectionID != selectedFrame?.id {
            currentSectionID = selectedFrame?.id
        }
    }

    private func menuThumbnailImageName(for item: VietnameseMenuItem) -> String {
        item.menuImageName
    }
}

private enum VietnameseMenuLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 20
    static let heroHeight: CGFloat = 240
    static let bottomChromeContentClearance: CGFloat = 132
    static let sectionCardSpacing: CGFloat = 12
    static let sectionCardHeight: CGFloat = 166
    static let sectionImageHeight: CGFloat = 108
    static let sectionActivationY: CGFloat = AppChromeLayout.menuSectionJumpClearance + 32
    static let sectionJumpViewportAnchorY: CGFloat = 0.19
    static let sectionJumpDelayNanoseconds: UInt64 = 80_000_000
    static let glassRailRevealY: CGFloat = 72

    static func sectionCardWidth(containerWidth: CGFloat) -> CGFloat {
        max(154, (containerWidth - horizontalPadding * 2 - sectionCardSpacing) / 2)
    }
}

private struct VietnameseMenuSectionImageCard: View {
    let accessibilityID: String
    let title: String
    let imageName: String
    let tintName: AccentTint
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: VietnameseMenuLayout.sectionImageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()

                Text(title)
                    .font(.headline.weight(.black))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
                    .background(.white.opacity(0.96))
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(isSelected ? tintName.color.opacity(0.50) : Color.black.opacity(0.06), lineWidth: isSelected ? 1.5 : 1)
                    .allowsHitTesting(false)
            }
            .shadow(color: .black.opacity(0.025), radius: 7, x: 0, y: 4)
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("VietnameseMenu.SectionRail.\(accessibilityID)")
    }
}

private struct VietnameseMenuSectionBlock: View {
    let section: VietnameseMenuSection
    let heroImageName: (VietnameseMenuItem) -> String
    let onOpenDetail: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(section.title)
                    .font(.title2.weight(.black))
                    .foregroundStyle(.primary)
                    .accessibilityIdentifier("VietnameseMenu.SectionTitle.\(section.id)")

                Text("\(section.itemCount)")
                    .font(.caption.weight(.black))
                    .foregroundStyle(section.tintName.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(section.tintName.color.opacity(0.10), in: Capsule(style: .continuous))

                Spacer(minLength: 0)
            }

            if !section.subtitle.isEmpty {
                Text(section.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    VietnameseMenuItemRow(
                        item: item,
                        heroImageName: heroImageName(item),
                        onOpenDetail: { onOpenDetail(item.detailPageID) }
                    )

                    if item.id != section.items.last?.id {
                        Divider().padding(.leading, 86)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .phraseListCard(cornerRadius: 24)
        }
    }
}

private struct VietnameseMenuItemRow: View {
    let item: VietnameseMenuItem
    let heroImageName: String
    let onOpenDetail: () -> Void

    var body: some View {
        Button(action: onOpenDetail) {
            HStack(spacing: 14) {
                Image(heroImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 62, height: 62)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                    }
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.vietnameseItem)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.74)

                    Text(item.englishTranslation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)

                Spacer(minLength: 0)

                if let audioKey = AudioAssetManifest.main?.audioKey(forExactText: item.vietnameseItem) {
                    AudioSpeakerButton(tint: item.kind?.tintName ?? .orange, audioKey: audioKey)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary.opacity(0.8))
                        .frame(width: 36, height: 36)
                        .nativeGlass(cornerRadius: 18, interactive: false)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("VietnameseMenu.Row.\(item.itemID)")
    }
}

struct VietnameseMenuSectionJumpRequest: Equatable {
    let requestID: Int
    let route: BrowseCollectionRoute
    let sectionID: String
}

struct VietnameseMenuSectionChromeItem: Identifiable, Equatable {
    let id: String
    let title: String
    let symbolName: String
    let tintName: AccentTint
}

struct VietnameseMenuSectionChromeState: Equatable {
    let route: BrowseCollectionRoute
    let currentSectionID: String
    let isPinned: Bool
    let sections: [VietnameseMenuSectionChromeItem]
}

struct VietnameseMenuSectionChromePreferenceKey: PreferenceKey {
    static var defaultValue: [VietnameseMenuSectionChromeState] = []

    static func reduce(value: inout [VietnameseMenuSectionChromeState], nextValue: () -> [VietnameseMenuSectionChromeState]) {
        value.append(contentsOf: nextValue())
    }
}

private struct VietnameseMenuSectionFrame: Equatable {
    let id: String
    let order: Int
    let minY: CGFloat
}

private struct VietnameseMenuSectionFramePreferenceKey: PreferenceKey {
    static var defaultValue: [VietnameseMenuSectionFrame] = []

    static func reduce(value: inout [VietnameseMenuSectionFrame], nextValue: () -> [VietnameseMenuSectionFrame]) {
        value.append(contentsOf: nextValue())
    }
}

private struct VietnameseMenuRailFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect?

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue() ?? value
    }
}
