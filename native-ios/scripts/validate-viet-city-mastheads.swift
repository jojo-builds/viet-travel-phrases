#!/usr/bin/env swift

import AppKit
import Foundation

struct CityMasthead {
    let name: String
    let sourcePath: String
    let outputPath: String
}

let repoRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let expectedPixels = CGSize(width: 853, height: 1844)
let minimumSourceBytes = 900_000
let minimumOutputBytes = 900_000

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

var failures: [String] = []

for masthead in mastheads {
    let sourceURL = absoluteURL(masthead.sourcePath)
    let outputURL = absoluteURL(masthead.outputPath)
    do {
        let sourceBytes = try fileSize(at: sourceURL)
        let outputBytes = try fileSize(at: outputURL)
        if sourceBytes < minimumSourceBytes {
            failures.append("\(masthead.name) source is too small: \(sourceBytes) bytes")
        }
        if outputBytes < minimumOutputBytes {
            failures.append("\(masthead.name) output is too small: \(outputBytes) bytes")
        }
        guard let image = NSImage(contentsOf: outputURL) else {
            failures.append("\(masthead.name) output could not be loaded")
            continue
        }
        guard
            let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        else {
            failures.append("\(masthead.name) output could not be inspected")
            continue
        }
        if cgImage.width != Int(expectedPixels.width) || cgImage.height != Int(expectedPixels.height) {
            failures.append("\(masthead.name) output is \(cgImage.width)x\(cgImage.height), expected \(Int(expectedPixels.width))x\(Int(expectedPixels.height))")
        }
        print("OK \(masthead.name): \(cgImage.width)x\(cgImage.height), \(outputBytes) bytes")
    } catch {
        failures.append("\(masthead.name): \(error.localizedDescription)")
    }
}

if !failures.isEmpty {
    for failure in failures {
        fputs("error: \(failure)\n", stderr)
    }
    exit(1)
}
