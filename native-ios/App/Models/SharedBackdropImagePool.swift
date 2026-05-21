import Foundation

enum SharedBackdropImagePool {
    enum Surface: String, CaseIterable {
        case home
        case browse
        case saved
        case practice
        case search
        case sharedPage
    }

    static let fallbackImageName = "HomeVietnamMapBackdrop"
    static let preheatLookaheadCount = 1

    static let vietnamForwardAssetNames = [
        "HomeVietnamMapBackdrop",
        "HeroCityDanangPlaceGoldenBridge",
        "HeroCityDanangPlaceDragonBridgeFireShow",
        "HeroCityDanangPlaceSonTra",
        "HeroCityDanangPlaceMarbleMountains",
        "HeroCityDanangPlaceHanRiver",
        "HeroCityHoianPlaceLanternBoat",
        "HeroCityHoianPlaceBayMauCoconutForest",
        "HeroCityHoianPlaceMySonSanctuary",
        "HeroCityHoianPlaceAnBangBeach",
        "HeroCityHuePlacePerfumeRiver",
        "HeroCityHuePlaceIncenseVillageWorkshop",
        "HeroCityHuePlaceAnHienGardenHouse",
        "HeroCityHuePlaceTuHieuPagoda",
        "HeroCityHanoiPlaceLongBienBridge",
        "HeroCityHanoiPlaceHoanKiemLake",
        "HeroCityHanoiPlaceQuangBaFlowerMarket",
        "HeroCityHcmcPlaceSaigonRiver",
        "HeroCityHcmcPlaceNotreDame",
        "HeroCityHcmcPlaceHoThiKyFlowerMarket",
    ]

    static func nextImageName(
        for surface: Surface,
        defaults: UserDefaults = .standard
    ) -> String {
        guard !vietnamForwardAssetNames.isEmpty else {
            return fallbackImageName
        }

        let key = storageKey(for: surface)
        let currentIndex = normalizedIndex(defaults.integer(forKey: key))
        let imageName = vietnamForwardAssetNames[currentIndex]
        defaults.set(normalizedIndex(currentIndex + 1), forKey: key)
        return imageName
    }

    static func preheatCandidateImageNames(
        selectedImageName: String,
        lookaheadCount: Int = preheatLookaheadCount
    ) -> [String] {
        guard !vietnamForwardAssetNames.isEmpty else {
            return [fallbackImageName]
        }

        let selectedIndex = vietnamForwardAssetNames.firstIndex(of: selectedImageName) ?? 0
        let count = max(lookaheadCount, 0)

        return (0...count).map { offset in
            vietnamForwardAssetNames[normalizedIndex(selectedIndex + offset)]
        }
    }

    static func storageKey(for surface: Surface) -> String {
        "SpeakLocal.SharedBackdropImagePool.nextIndex.\(surface.rawValue)"
    }

    private static func normalizedIndex(_ index: Int) -> Int {
        guard !vietnamForwardAssetNames.isEmpty else {
            return 0
        }

        return ((index % vietnamForwardAssetNames.count) + vietnamForwardAssetNames.count) % vietnamForwardAssetNames.count
    }
}
