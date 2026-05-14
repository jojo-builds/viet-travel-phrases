#!/usr/bin/env swift

import AppKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct Manifest: Decodable {
    let items: [MenuImageRow]
}

struct MenuImageRow: Decodable {
    let itemID: String
    let menuType: String
    let category: String
    let vietnameseItem: String
    let englishTranslation: String
    let imagesetPath: String
    let filename: String
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
        throw NSError(domain: "MenuContactSheet", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not encode contact sheet"])
    }

    CGImageDestinationAddImage(destination, cgImage, [kCGImageDestinationLossyCompressionQuality: 0.9] as CFDictionary)
    if !CGImageDestinationFinalize(destination) {
        throw NSError(domain: "MenuContactSheet", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not write contact sheet"])
    }
}

let repoRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
let manifestURL = repoRoot
    .appendingPathComponent("native-ios/artifacts/vietnamese-menu/menu-image-manifest.json")
let outputDir = repoRoot
    .appendingPathComponent("native-ios/artifacts/vietnamese-menu/contact-sheets", isDirectory: true)

let manifest = try JSONDecoder().decode(Manifest.self, from: Data(contentsOf: manifestURL))
try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

let grouped = Dictionary(grouping: manifest.items) { "\($0.menuType) / \($0.category)" }
let orderedKeys = grouped.keys.sorted()

let columns = 4
let cardWidth: CGFloat = 250
let cardHeight: CGFloat = 324
let margin: CGFloat = 24
let headerHeight: CGFloat = 74
let imageSize: CGFloat = 210
let canvasWidth = margin * 2 + CGFloat(columns) * cardWidth

for key in orderedKeys {
    guard let rows = grouped[key] else { continue }
    let gridRows = Int(ceil(Double(rows.count) / Double(columns)))
    let canvasHeight = margin * 2 + headerHeight + CGFloat(gridRows) * cardHeight
    let canvas = NSImage(size: NSSize(width: canvasWidth, height: canvasHeight))

    canvas.lockFocus()
    NSColor(calibratedWhite: 0.97, alpha: 1).setFill()
    NSRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight).fill()

    drawText(key, in: NSRect(x: margin, y: canvasHeight - margin - 36, width: canvasWidth - margin * 2, height: 36), font: .boldSystemFont(ofSize: 24), color: .black)
    drawText("\(rows.count) unique menu images", in: NSRect(x: margin, y: canvasHeight - margin - 62, width: canvasWidth - margin * 2, height: 24), font: .systemFont(ofSize: 14), color: .darkGray)

    for (index, row) in rows.enumerated() {
        let column = index % columns
        let gridRow = index / columns
        let x = margin + CGFloat(column) * cardWidth
        let y = canvasHeight - margin - headerHeight - CGFloat(gridRow + 1) * cardHeight
        let cardRect = NSRect(x: x + 8, y: y + 8, width: cardWidth - 16, height: cardHeight - 16)

        NSColor.white.setFill()
        NSBezierPath(roundedRect: cardRect, xRadius: 12, yRadius: 12).fill()

        let imageURL = repoRoot
            .appendingPathComponent(row.imagesetPath, isDirectory: true)
            .appendingPathComponent(row.filename)
        if let itemImage = NSImage(contentsOf: imageURL) {
            itemImage.draw(
                in: NSRect(x: cardRect.minX + 12, y: cardRect.maxY - 12 - imageSize, width: imageSize, height: imageSize),
                from: .zero,
                operation: .sourceOver,
                fraction: 1
            )
        }

        drawText(row.vietnameseItem, in: NSRect(x: cardRect.minX + 12, y: cardRect.minY + 58, width: cardRect.width - 24, height: 24), font: .boldSystemFont(ofSize: 15), color: .black)
        drawText(row.englishTranslation, in: NSRect(x: cardRect.minX + 12, y: cardRect.minY + 34, width: cardRect.width - 24, height: 22), font: .systemFont(ofSize: 12), color: .darkGray)
        drawText(row.itemID, in: NSRect(x: cardRect.minX + 12, y: cardRect.minY + 14, width: cardRect.width - 24, height: 18), font: .monospacedSystemFont(ofSize: 9, weight: .regular), color: .gray)
    }

    canvas.unlockFocus()

    let fileName = "\(slug(key)).jpg"
    try saveJPEG(canvas, to: outputDir.appendingPathComponent(fileName))
    print(fileName)
}

print("Wrote \(orderedKeys.count) menu image contact sheets to \(outputDir.path)")
