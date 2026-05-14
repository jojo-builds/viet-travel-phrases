#!/usr/bin/env swift

import AppKit
import CryptoKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct Arguments {
    var sheetPath: String?
    var itemIDs: [String] = []
    var columns = 3
    var rows = 3
    var inset = 6
    var targetSize = 720
    var assetRoot = "native-ios/Resources/Assets.xcassets"
}

func usage() -> Never {
    FileHandle.standardError.write(
        """
        Usage:
          crop-vietnamese-menu-contact-sheet.swift --sheet <png> --items <id,id,...> [--columns 3] [--rows 3] [--asset-root <Assets.xcassets>] [--target-size 720] [--inset 6]

        Crops a generated food-photo contact sheet into per-menu-item .imageset assets.
        Items are assigned left-to-right, top-to-bottom.
        \n
        """.data(using: .utf8)!
    )
    exit(2)
}

func parseArguments() -> Arguments {
    var parsed = Arguments()
    var index = 1
    while index < CommandLine.arguments.count {
        let key = CommandLine.arguments[index]
        guard index + 1 < CommandLine.arguments.count else {
            usage()
        }
        let value = CommandLine.arguments[index + 1]
        switch key {
        case "--sheet":
            parsed.sheetPath = value
        case "--items":
            parsed.itemIDs = value.split(separator: ",").map(String.init).filter { !$0.isEmpty }
        case "--columns":
            parsed.columns = Int(value) ?? parsed.columns
        case "--rows":
            parsed.rows = Int(value) ?? parsed.rows
        case "--inset":
            parsed.inset = Int(value) ?? parsed.inset
        case "--target-size":
            parsed.targetSize = Int(value) ?? parsed.targetSize
        case "--asset-root":
            parsed.assetRoot = value
        default:
            usage()
        }
        index += 2
    }

    guard parsed.sheetPath != nil,
          !parsed.itemIDs.isEmpty,
          parsed.columns > 0,
          parsed.rows > 0,
          parsed.itemIDs.count <= parsed.columns * parsed.rows
    else {
        usage()
    }

    return parsed
}

func assetName(for itemID: String) -> String {
    "HeroMenu" + itemID
        .split(separator: "-")
        .map { component in
            component.prefix(1).uppercased() + component.dropFirst()
        }
        .joined()
}

func writeJPEG(_ cgImage: CGImage, to url: URL, quality: CGFloat) throws {
    guard let destination = CGImageDestinationCreateWithURL(
        url as CFURL,
        UTType.jpeg.identifier as CFString,
        1,
        nil
    ) else {
        throw NSError(domain: "MenuImageCropper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not encode JPEG"])
    }

    CGImageDestinationAddImage(
        destination,
        cgImage,
        [kCGImageDestinationLossyCompressionQuality: quality] as CFDictionary
    )

    if !CGImageDestinationFinalize(destination) {
        throw NSError(domain: "MenuImageCropper", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not write JPEG"])
    }
}

func resize(_ cgImage: CGImage, targetSize: Int) -> CGImage {
    guard cgImage.width != targetSize || cgImage.height != targetSize else {
        return cgImage
    }

    guard let context = CGContext(
        data: nil,
        width: targetSize,
        height: targetSize,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    ) else {
        return cgImage
    }

    context.interpolationQuality = .high
    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: targetSize, height: targetSize))
    return context.makeImage() ?? cgImage
}

let args = parseArguments()
let sheetURL = URL(fileURLWithPath: args.sheetPath!)
let assetRoot = URL(fileURLWithPath: args.assetRoot, isDirectory: true)
let fileManager = FileManager.default

guard let sourceImage = NSImage(contentsOf: sheetURL),
      let sourceData = sourceImage.tiffRepresentation,
      let sourceBitmap = NSBitmapImageRep(data: sourceData),
      let sourceCG = sourceBitmap.cgImage
else {
    FileHandle.standardError.write("Could not read contact sheet at \(sheetURL.path)\n".data(using: .utf8)!)
    exit(1)
}

let cellWidth = sourceCG.width / args.columns
let cellHeight = sourceCG.height / args.rows
let cropInset = max(0, args.inset)
var created: [String] = []

for (index, itemID) in args.itemIDs.enumerated() {
    let column = index % args.columns
    let row = index / args.columns
    let cropRect = CGRect(
        x: column * cellWidth + cropInset,
        y: row * cellHeight + cropInset,
        width: max(1, cellWidth - cropInset * 2),
        height: max(1, cellHeight - cropInset * 2)
    )

    guard let cropped = sourceCG.cropping(to: cropRect) else {
        FileHandle.standardError.write("Could not crop item \(itemID)\n".data(using: .utf8)!)
        exit(1)
    }

    let resized = resize(cropped, targetSize: args.targetSize)
    let name = assetName(for: itemID)
    let imagesetURL = assetRoot.appendingPathComponent("\(name).imageset", isDirectory: true)
    try fileManager.createDirectory(at: imagesetURL, withIntermediateDirectories: true)

    let imageFileName = "hero-menu-\(itemID).jpg"
    try writeJPEG(resized, to: imagesetURL.appendingPathComponent(imageFileName), quality: 0.88)

    let contents = """
    {
      "images": [
        {
          "filename": "\(imageFileName)",
          "idiom": "universal",
          "scale": "1x"
        }
      ],
      "info": {
        "author": "xcode",
        "version": 1
      }
    }
    """
    try contents.write(to: imagesetURL.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    created.append(name)
}

print("Created \(created.count) menu image assets")
for name in created {
    print(name)
}
