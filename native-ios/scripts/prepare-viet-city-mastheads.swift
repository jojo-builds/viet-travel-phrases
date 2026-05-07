#!/usr/bin/env swift

import AppKit
import Foundation

struct CityMasthead {
    let name: String
    let sourcePath: String
    let outputPath: String
}

let repoRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let targetPixels = CGSize(width: 853, height: 1844)
let minimumSourceBytes = 900_000

let mastheads = [
    CityMasthead(
        name: "Hanoi",
        sourcePath: "docs/design/category-pages/assets/city-masthead-sources/hanoi-source.png",
        outputPath: "native-ios/Resources/Assets.xcassets/HeroCityHanoi.imageset/hero-city-hanoi.png"
    ),
    CityMasthead(
        name: "Saigon",
        sourcePath: "docs/design/category-pages/assets/city-masthead-sources/hcmc-source.png",
        outputPath: "native-ios/Resources/Assets.xcassets/HeroCityHcmc.imageset/hero-city-hcmc.png"
    ),
    CityMasthead(
        name: "Da Nang",
        sourcePath: "docs/design/category-pages/assets/city-masthead-sources/danang-source.png",
        outputPath: "native-ios/Resources/Assets.xcassets/HeroCityDanang.imageset/hero-city-danang.png"
    ),
    CityMasthead(
        name: "Hoi An",
        sourcePath: "docs/design/category-pages/assets/city-masthead-sources/hoian-source.png",
        outputPath: "native-ios/Resources/Assets.xcassets/HeroCityHoian.imageset/hero-city-hoian.png"
    ),
    CityMasthead(
        name: "Hue",
        sourcePath: "docs/design/category-pages/assets/city-masthead-sources/hue-source.png",
        outputPath: "native-ios/Resources/Assets.xcassets/HeroCityHue.imageset/hero-city-hue.png"
    )
]

func absoluteURL(_ path: String) -> URL {
    repoRoot.appendingPathComponent(path)
}

func fileSize(at url: URL) throws -> Int {
    let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
    return attributes[.size] as? Int ?? 0
}

func renderMasthead(source: NSImage, outputURL: URL) throws {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(targetPixels.width),
        pixelsHigh: Int(targetPixels.height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw NSError(domain: "CityMasthead", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not create bitmap for \(outputURL.path)"])
    }

    let context = NSGraphicsContext(bitmapImageRep: bitmap)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    NSColor.white.setFill()
    NSRect(origin: .zero, size: targetPixels).fill()

    let sourceSize = source.size
    let scale = max(targetPixels.width / sourceSize.width, targetPixels.height / sourceSize.height)
    let drawSize = CGSize(width: sourceSize.width * scale, height: sourceSize.height * scale)
    let drawOrigin = CGPoint(
        x: (targetPixels.width - drawSize.width) / 2,
        y: (targetPixels.height - drawSize.height) / 2
    )
    source.draw(
        in: NSRect(origin: drawOrigin, size: drawSize),
        from: .zero,
        operation: .sourceOver,
        fraction: 1,
        respectFlipped: false,
        hints: [.interpolation: NSImageInterpolation.high]
    )
    context?.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()

    guard let data = bitmap.representation(using: .png, properties: [.compressionFactor: 0.92]) else {
        throw NSError(domain: "CityMasthead", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not encode \(outputURL.path)"])
    }
    try data.write(to: outputURL)
}

var failed = false

for masthead in mastheads {
    let sourceURL = absoluteURL(masthead.sourcePath)
    let outputURL = absoluteURL(masthead.outputPath)
    do {
        let bytes = try fileSize(at: sourceURL)
        guard bytes >= minimumSourceBytes else {
            throw NSError(
                domain: "CityMasthead",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "\(masthead.name) source is too small for premium masthead art: \(bytes) bytes"]
            )
        }
        guard let image = NSImage(contentsOf: sourceURL) else {
            throw NSError(domain: "CityMasthead", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not load \(sourceURL.path)"])
        }
        try renderMasthead(source: image, outputURL: outputURL)
        let outputBytes = try fileSize(at: outputURL)
        print("Rendered \(masthead.name): \(outputURL.path) (\(outputBytes) bytes)")
    } catch {
        failed = true
        fputs("error: \(error.localizedDescription)\n", stderr)
    }
}

if failed {
    exit(1)
}
