#!/usr/bin/env swift

import AppKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct Manifest: Decodable {
    let rows: [MenuBackdropRow]
}

struct MenuBackdropRow: Decodable {
    let itemID: String
    let menuType: String
    let category: String
    let vietnameseItem: String
    let englishTranslation: String
    let backdropAssetName: String
    let assetPath: String?
    let bakeoff: [String: BakeoffImage]?
}

struct BakeoffImage: Decodable {
    let runtimeImagePath: String
}

func parseArgs() -> [String: String] {
    var result: [String: String] = [:]
    var index = 1
    while index < CommandLine.arguments.count {
        let key = CommandLine.arguments[index]
        guard key.starts(with: "--"), index + 1 < CommandLine.arguments.count else {
            index += 1
            continue
        }
        result[String(key.dropFirst(2))] = CommandLine.arguments[index + 1]
        index += 2
    }
    return result
}

func slug(_ value: String) -> String {
    value
        .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
        .lowercased()
        .replacingOccurrences(of: "đ", with: "d")
        .replacingOccurrences(of: "&", with: "and")
        .replacingOccurrences(of: #"[^a-z0-9]+"#, with: "-", options: .regularExpression)
        .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
}

func drawText(_ text: String, in rect: NSRect, font: NSFont, color: NSColor, alignment: NSTextAlignment = .left) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineBreakMode = .byTruncatingTail
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: color,
        .paragraphStyle: paragraph,
    ]
    (text as NSString).draw(in: rect, withAttributes: attributes)
}

func saveJPEG(_ image: NSImage, to url: URL) throws {
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let cgImage = bitmap.cgImage,
          let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.jpeg.identifier as CFString, 1, nil)
    else {
        throw NSError(domain: "MenuBackdropContactSheet", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not encode contact sheet"])
    }

    CGImageDestinationAddImage(destination, cgImage, [kCGImageDestinationLossyCompressionQuality: 0.9] as CFDictionary)
    if !CGImageDestinationFinalize(destination) {
        throw NSError(domain: "MenuBackdropContactSheet", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not write contact sheet"])
    }
}

let repoRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
let args = parseArgs()
let profile = args["bakeoff-profile"]
let manifestURL = repoRoot
    .appendingPathComponent("docs/editorial-exports/viet-image-assets/menu-backdrop-production-355/manifest.json")
let outputDir = repoRoot
    .appendingPathComponent(
        profile.map { "docs/editorial-exports/viet-image-assets/menu-backdrop-production-355/review-contact-sheets/bakeoff-\($0)" }
            ?? "docs/editorial-exports/viet-image-assets/menu-backdrop-production-355/review-contact-sheets/runtime",
        isDirectory: true
    )

let manifest = try JSONDecoder().decode(Manifest.self, from: Data(contentsOf: manifestURL))
try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

func imagePath(for row: MenuBackdropRow) -> String? {
    if let profile {
        return row.bakeoff?[profile]?.runtimeImagePath
    }
    return row.assetPath
}

let rows = manifest.rows.filter { imagePath(for: $0) != nil }
let grouped = Dictionary(grouping: rows) { "\($0.menuType) / \($0.category)" }
let orderedKeys = grouped.keys.sorted()

if rows.isEmpty {
    fputs("No menu backdrop rows have images for this contact-sheet mode.\n", stderr)
    exit(1)
}

if profile == nil && rows.count != manifest.rows.count {
    fputs("Runtime contact sheets require all \(manifest.rows.count) menu backdrop rows; found \(rows.count).\n", stderr)
    exit(1)
}

let columns = 4
let cardWidth: CGFloat = 246
let cardHeight: CGFloat = 420
let margin: CGFloat = 24
let headerHeight: CGFloat = 76
let imageWidth: CGFloat = 156
let imageHeight: CGFloat = 312
let canvasWidth = margin * 2 + CGFloat(columns) * cardWidth

for key in orderedKeys {
    guard let groupRows = grouped[key] else { continue }
    let gridRows = Int(ceil(Double(groupRows.count) / Double(columns)))
    let canvasHeight = margin * 2 + headerHeight + CGFloat(gridRows) * cardHeight
    let canvas = NSImage(size: NSSize(width: canvasWidth, height: canvasHeight))

    canvas.lockFocus()
    NSColor(calibratedWhite: 0.97, alpha: 1).setFill()
    NSRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight).fill()

    let title = profile.map { "\(key) - \($0)" } ?? key
    drawText(title, in: NSRect(x: margin, y: canvasHeight - margin - 36, width: canvasWidth - margin * 2, height: 36), font: .boldSystemFont(ofSize: 24), color: .black)
    drawText("\(groupRows.count) portrait menu backdrop images", in: NSRect(x: margin, y: canvasHeight - margin - 62, width: canvasWidth - margin * 2, height: 24), font: .systemFont(ofSize: 14), color: .darkGray)

    for (index, row) in groupRows.enumerated() {
        let column = index % columns
        let gridRow = index / columns
        let x = margin + CGFloat(column) * cardWidth
        let y = canvasHeight - margin - headerHeight - CGFloat(gridRow + 1) * cardHeight
        let cardRect = NSRect(x: x + 8, y: y + 8, width: cardWidth - 16, height: cardHeight - 16)

        NSColor.white.setFill()
        NSBezierPath(roundedRect: cardRect, xRadius: 12, yRadius: 12).fill()

        if let relativePath = imagePath(for: row) {
            let imageURL = repoRoot.appendingPathComponent(relativePath)
            if let image = NSImage(contentsOf: imageURL) {
                image.draw(
                    in: NSRect(x: cardRect.midX - imageWidth / 2, y: cardRect.maxY - 12 - imageHeight, width: imageWidth, height: imageHeight),
                    from: .zero,
                    operation: .sourceOver,
                    fraction: 1
                )
            }
        }

        drawText(row.vietnameseItem, in: NSRect(x: cardRect.minX + 12, y: cardRect.minY + 48, width: cardRect.width - 24, height: 24), font: .boldSystemFont(ofSize: 14), color: .black)
        drawText(row.englishTranslation, in: NSRect(x: cardRect.minX + 12, y: cardRect.minY + 27, width: cardRect.width - 24, height: 20), font: .systemFont(ofSize: 11), color: .darkGray)
        drawText(row.itemID, in: NSRect(x: cardRect.minX + 12, y: cardRect.minY + 10, width: cardRect.width - 24, height: 16), font: .monospacedSystemFont(ofSize: 8, weight: .regular), color: .gray)
    }

    canvas.unlockFocus()

    let fileName = "\(slug(title)).jpg"
    try saveJPEG(canvas, to: outputDir.appendingPathComponent(fileName))
    print(fileName)
}

print("Wrote \(orderedKeys.count) menu backdrop contact sheets to \(outputDir.path)")
