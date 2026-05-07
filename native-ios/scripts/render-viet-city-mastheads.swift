#!/usr/bin/env swift

import AppKit
import CoreGraphics
import Foundation

private let width = 853
private let height = 1844
private let sceneBottom: CGFloat = 610

private struct RGB {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var a: CGFloat = 1

    init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) {
        self.r = r / 255
        self.g = g / 255
        self.b = b / 255
        self.a = a
    }

    var color: CGColor {
        CGColor(red: r, green: g, blue: b, alpha: a)
    }
}

private enum Palette {
    static let skyTop = RGB(211, 238, 248)
    static let skyMid = RGB(236, 246, 249)
    static let page = RGB(247, 249, 250)
    static let white = RGB(255, 255, 255)
    static let mist = RGB(255, 255, 255, 0.72)
    static let ink = RGB(37, 50, 58)
    static let red = RGB(248, 49, 60)
    static let deepRed = RGB(185, 53, 49)
    static let gold = RGB(220, 143, 18)
    static let paleGold = RGB(246, 217, 150)
    static let green = RGB(60, 149, 103)
    static let darkGreen = RGB(39, 120, 87)
    static let blue = RGB(62, 145, 194)
    static let water = RGB(137, 207, 218)
    static let stone = RGB(171, 181, 176)
    static let cream = RGB(248, 230, 188)
    static let yellowWall = RGB(247, 222, 164)
    static let roof = RGB(160, 91, 59)
    static let shadow = RGB(64, 72, 68, 0.18)
}

private struct CityHero {
    let assetName: String
    let fileName: String
    let draw: (CGContext) -> Void
}

private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    a + (b - a) * t
}

private func fill(_ ctx: CGContext, _ color: RGB) {
    ctx.setFillColor(color.color)
}

private func stroke(_ ctx: CGContext, _ color: RGB, width: CGFloat, lineCap: CGLineCap = .round) {
    ctx.setStrokeColor(color.color)
    ctx.setLineWidth(width)
    ctx.setLineCap(lineCap)
    ctx.setLineJoin(.round)
}

private func rect(_ ctx: CGContext, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, color: RGB) {
    fill(ctx, color)
    ctx.fill(CGRect(x: x, y: y, width: w, height: h))
}

private func rounded(_ ctx: CGContext, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, radius: CGFloat, color: RGB) {
    fill(ctx, color)
    ctx.addPath(CGPath(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.fillPath()
}

private func ellipse(_ ctx: CGContext, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, color: RGB) {
    fill(ctx, color)
    ctx.fillEllipse(in: CGRect(x: x, y: y, width: w, height: h))
}

private func polygon(_ ctx: CGContext, points: [CGPoint], color: RGB) {
    guard let first = points.first else { return }
    let path = CGMutablePath()
    path.move(to: first)
    for point in points.dropFirst() {
        path.addLine(to: point)
    }
    path.closeSubpath()
    fill(ctx, color)
    ctx.addPath(path)
    ctx.fillPath()
}

private func line(_ ctx: CGContext, _ points: [CGPoint], color: RGB, width: CGFloat, cap: CGLineCap = .round) {
    guard let first = points.first else { return }
    stroke(ctx, color, width: width, lineCap: cap)
    ctx.beginPath()
    ctx.move(to: first)
    for point in points.dropFirst() {
        ctx.addLine(to: point)
    }
    ctx.strokePath()
}

private func arc(_ ctx: CGContext, rect: CGRect, start: CGFloat, end: CGFloat, color: RGB, width: CGFloat) {
    stroke(ctx, color, width: width)
    ctx.addArc(
        center: CGPoint(x: rect.midX, y: rect.midY),
        radius: rect.width / 2,
        startAngle: start * .pi / 180,
        endAngle: end * .pi / 180,
        clockwise: false
    )
    ctx.strokePath()
}

private func quadratic(_ ctx: CGContext, from: CGPoint, control: CGPoint, to: CGPoint, color: RGB, width: CGFloat) {
    stroke(ctx, color, width: width)
    ctx.beginPath()
    ctx.move(to: from)
    ctx.addQuadCurve(to: to, control: control)
    ctx.strokePath()
}

private func drawGradient(_ ctx: CGContext, from top: RGB, to bottom: RGB, rect: CGRect) {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colors = [top.color, bottom.color] as CFArray
    let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0, 1])!
    ctx.drawLinearGradient(
        gradient,
        start: CGPoint(x: rect.midX, y: rect.minY),
        end: CGPoint(x: rect.midX, y: rect.maxY),
        options: []
    )
}

private func drawBase(_ ctx: CGContext) {
    drawGradient(ctx, from: Palette.skyTop, to: Palette.skyMid, rect: CGRect(x: 0, y: 0, width: width, height: height))

    drawCloud(ctx, x: 86, y: 88, scale: 0.95, alpha: 0.84)
    drawCloud(ctx, x: 624, y: 70, scale: 0.7, alpha: 0.78)
    drawCloud(ctx, x: 518, y: 202, scale: 0.55, alpha: 0.62)

    rect(ctx, x: 0, y: 430, w: CGFloat(width), h: CGFloat(height) - 430, color: RGB(247, 249, 250, 0.15))
}

private func drawCloud(_ ctx: CGContext, x: CGFloat, y: CGFloat, scale: CGFloat, alpha: CGFloat) {
    let c = RGB(255, 255, 255, alpha)
    ellipse(ctx, x: x, y: y + 26 * scale, w: 54 * scale, h: 34 * scale, color: c)
    ellipse(ctx, x: x + 40 * scale, y: y, w: 72 * scale, h: 56 * scale, color: c)
    ellipse(ctx, x: x + 104 * scale, y: y + 22 * scale, w: 56 * scale, h: 38 * scale, color: c)
    ellipse(ctx, x: x + 150 * scale, y: y + 30 * scale, w: 42 * scale, h: 30 * scale, color: c)
}

private func drawBottomMist(_ ctx: CGContext) {
    rect(ctx, x: 0, y: 360, w: CGFloat(width), h: 105, color: RGB(255, 255, 255, 0.20))
    rect(ctx, x: 0, y: 430, w: CGFloat(width), h: 130, color: RGB(255, 255, 255, 0.38))
    rect(ctx, x: 0, y: 520, w: CGFloat(width), h: 190, color: RGB(255, 255, 255, 0.72))
    rect(ctx, x: 0, y: 690, w: CGFloat(width), h: CGFloat(height) - 690, color: RGB(247, 249, 250, 0.96))
}

private func drawWater(_ ctx: CGContext, y: CGFloat, color: RGB = Palette.water) {
    rect(ctx, x: 0, y: y, w: CGFloat(width), h: sceneBottom - y, color: color)
    for offset in stride(from: -100, through: CGFloat(width), by: 90) {
        quadratic(
            ctx,
            from: CGPoint(x: offset, y: y + 76),
            control: CGPoint(x: offset + 70, y: y + 36),
            to: CGPoint(x: offset + 150, y: y + 76),
            color: RGB(255, 255, 255, 0.36),
            width: 3
        )
    }
}

private func drawBuilding(
    _ ctx: CGContext,
    x: CGFloat,
    y: CGFloat,
    w: CGFloat,
    h: CGFloat,
    body: RGB,
    roof: RGB,
    columns: Int = 3
) {
    rounded(ctx, x: x, y: y, w: w, h: h, radius: 8, color: body)
    polygon(ctx, points: [
        CGPoint(x: x - 18, y: y),
        CGPoint(x: x + w / 2, y: y - 48),
        CGPoint(x: x + w + 18, y: y),
    ], color: roof)
    for index in 0..<columns {
        let step = w / CGFloat(max(columns + 1, 2))
        let cx = x + step * CGFloat(index + 1)
        rounded(ctx, x: cx - 14, y: y + 48, w: 28, h: h - 68, radius: 10, color: RGB(255, 255, 255, 0.72))
    }
}

private func drawTree(_ ctx: CGContext, x: CGFloat, y: CGFloat, scale: CGFloat = 1) {
    rounded(ctx, x: x + 26 * scale, y: y + 70 * scale, w: 18 * scale, h: 92 * scale, radius: 8 * scale, color: RGB(116, 82, 54))
    ellipse(ctx, x: x, y: y, w: 74 * scale, h: 82 * scale, color: Palette.green)
    ellipse(ctx, x: x + 36 * scale, y: y + 18 * scale, w: 70 * scale, h: 74 * scale, color: RGB(95, 159, 110))
    ellipse(ctx, x: x + 14 * scale, y: y + 46 * scale, w: 80 * scale, h: 72 * scale, color: RGB(106, 169, 116))
}

private func drawLantern(_ ctx: CGContext, x: CGFloat, y: CGFloat, color: RGB, scale: CGFloat = 1) {
    line(ctx, [CGPoint(x: x, y: y - 18 * scale), CGPoint(x: x, y: y)], color: RGB(117, 86, 52, 0.55), width: 2 * scale)
    ellipse(ctx, x: x - 18 * scale, y: y, w: 36 * scale, h: 52 * scale, color: color)
    line(ctx, [CGPoint(x: x - 15 * scale, y: y + 22 * scale), CGPoint(x: x + 15 * scale, y: y + 22 * scale)], color: RGB(255, 255, 255, 0.34), width: 2 * scale)
}

private func drawHanoi(_ ctx: CGContext) {
    drawBase(ctx)
    drawWater(ctx, y: 316, color: RGB(144, 210, 205))

    ellipse(ctx, x: 80, y: 265, w: 680, h: 250, color: RGB(96, 162, 142, 0.18))
    quadratic(ctx, from: CGPoint(x: 108, y: 302), control: CGPoint(x: 330, y: 198), to: CGPoint(x: 520, y: 290), color: Palette.deepRed, width: 20)
    for x in stride(from: 135, through: 475, by: 58) {
        line(ctx, [CGPoint(x: x, y: 292), CGPoint(x: x + 8, y: 370)], color: Palette.deepRed, width: 6)
    }

    drawBuilding(ctx, x: 355, y: 202, w: 124, h: 150, body: Palette.yellowWall, roof: Palette.roof, columns: 2)
    rounded(ctx, x: 389, y: 164, w: 58, h: 48, radius: 5, color: Palette.yellowWall)
    polygon(ctx, points: [
        CGPoint(x: 373, y: 164),
        CGPoint(x: 418, y: 126),
        CGPoint(x: 463, y: 164),
    ], color: Palette.deepRed)
    rounded(ctx, x: 410, y: 94, w: 16, h: 42, radius: 5, color: Palette.deepRed)

    drawTree(ctx, x: 70, y: 250, scale: 0.9)
    drawTree(ctx, x: 664, y: 230, scale: 0.82)
    drawBottomMist(ctx)
}

private func drawHcmc(_ ctx: CGContext) {
    drawBase(ctx)
    drawWater(ctx, y: 372, color: RGB(156, 211, 221))

    rect(ctx, x: 78, y: 256, w: 74, h: 170, color: RGB(139, 189, 211))
    rect(ctx, x: 170, y: 196, w: 88, h: 232, color: RGB(125, 177, 207))
    rect(ctx, x: 280, y: 270, w: 70, h: 158, color: RGB(155, 199, 218))
    polygon(ctx, points: [
        CGPoint(x: 635, y: 124),
        CGPoint(x: 684, y: 356),
        CGPoint(x: 594, y: 356),
    ], color: RGB(89, 151, 194))
    rect(ctx, x: 622, y: 314, w: 122, h: 122, color: RGB(109, 176, 204))

    rounded(ctx, x: 396, y: 242, w: 166, h: 154, radius: 8, color: Palette.cream)
    polygon(ctx, points: [
        CGPoint(x: 374, y: 242),
        CGPoint(x: 480, y: 190),
        CGPoint(x: 584, y: 242),
    ], color: Palette.roof)
    rounded(ctx, x: 452, y: 198, w: 56, h: 44, radius: 6, color: Palette.cream)
    polygon(ctx, points: [
        CGPoint(x: 438, y: 198),
        CGPoint(x: 480, y: 164),
        CGPoint(x: 522, y: 198),
    ], color: Palette.roof)
    for x in [424, 478, 532] {
        rounded(ctx, x: CGFloat(x), y: 286, w: 26, h: 72, radius: 8, color: RGB(255, 255, 255, 0.72))
    }

    for x in stride(from: 100, through: 730, by: 70) {
        drawLantern(ctx, x: CGFloat(x), y: 230 + CGFloat(x % 3) * 16, color: x % 140 == 0 ? Palette.gold : Palette.red, scale: 0.58)
    }

    drawBottomMist(ctx)
}

private func drawDanang(_ ctx: CGContext) {
    drawBase(ctx)
    polygon(ctx, points: [
        CGPoint(x: -70, y: 336),
        CGPoint(x: 110, y: 130),
        CGPoint(x: 260, y: 338),
    ], color: RGB(104, 158, 128, 0.78))
    polygon(ctx, points: [
        CGPoint(x: 430, y: 340),
        CGPoint(x: 578, y: 168),
        CGPoint(x: 745, y: 340),
    ], color: RGB(114, 170, 139, 0.62))
    drawWater(ctx, y: 330, color: RGB(147, 207, 218))

    line(ctx, [
        CGPoint(x: 76, y: 330),
        CGPoint(x: 160, y: 250),
        CGPoint(x: 260, y: 284),
        CGPoint(x: 360, y: 238),
        CGPoint(x: 470, y: 286),
        CGPoint(x: 590, y: 250),
        CGPoint(x: 720, y: 330),
    ], color: Palette.gold, width: 18)
    for x in stride(from: 126, through: 650, by: 90) {
        line(ctx, [CGPoint(x: CGFloat(x), y: 324), CGPoint(x: CGFloat(x), y: 404)], color: RGB(174, 153, 125), width: 8)
    }

    rounded(ctx, x: 610, y: 255, w: 78, h: 88, radius: 18, color: RGB(245, 248, 248, 0.92))
    polygon(ctx, points: [
        CGPoint(x: 648, y: 210),
        CGPoint(x: 705, y: 278),
        CGPoint(x: 590, y: 278),
    ], color: Palette.deepRed)
    line(ctx, [CGPoint(x: 648, y: 210), CGPoint(x: 648, y: 360)], color: RGB(93, 108, 104), width: 3)

    drawBottomMist(ctx)
}

private func drawHoian(_ ctx: CGContext) {
    drawBase(ctx)
    drawWater(ctx, y: 360, color: RGB(151, 205, 197))

    drawBuilding(ctx, x: 88, y: 224, w: 204, h: 158, body: Palette.yellowWall, roof: Palette.deepRed, columns: 2)
    drawBuilding(ctx, x: 572, y: 226, w: 220, h: 156, body: RGB(247, 224, 178), roof: Palette.roof, columns: 2)

    rounded(ctx, x: 300, y: 248, w: 252, h: 130, radius: 18, color: RGB(105, 76, 58))
    for x in stride(from: 334, through: 492, by: 52) {
        rounded(ctx, x: CGFloat(x), y: 286, w: 34, h: 72, radius: 17, color: RGB(231, 169, 78))
    }
    polygon(ctx, points: [
        CGPoint(x: 282, y: 248),
        CGPoint(x: 426, y: 186),
        CGPoint(x: 572, y: 248),
    ], color: RGB(96, 59, 48))
    quadratic(ctx, from: CGPoint(x: 304, y: 380), control: CGPoint(x: 426, y: 278), to: CGPoint(x: 552, y: 380), color: RGB(171, 153, 125), width: 14)

    for (index, x) in stride(from: 112, through: 750, by: 76).enumerated() {
        let color = index % 3 == 0 ? Palette.red : (index % 3 == 1 ? Palette.gold : RGB(242, 190, 87))
        drawLantern(ctx, x: CGFloat(x), y: 112 + CGFloat(index % 2) * 18, color: color, scale: 0.72)
    }

    drawBottomMist(ctx)
}

private func drawHue(_ ctx: CGContext) {
    drawBase(ctx)
    drawWater(ctx, y: 374, color: RGB(157, 205, 216))

    rounded(ctx, x: 150, y: 258, w: 552, h: 146, radius: 12, color: Palette.yellowWall)
    polygon(ctx, points: [
        CGPoint(x: 116, y: 258),
        CGPoint(x: 426, y: 188),
        CGPoint(x: 736, y: 258),
    ], color: Palette.deepRed)
    rounded(ctx, x: 360, y: 180, w: 132, h: 86, radius: 8, color: Palette.yellowWall)
    polygon(ctx, points: [
        CGPoint(x: 333, y: 180),
        CGPoint(x: 426, y: 128),
        CGPoint(x: 520, y: 180),
    ], color: Palette.deepRed)
    rounded(ctx, x: 400, y: 96, w: 52, h: 72, radius: 6, color: Palette.yellowWall)
    polygon(ctx, points: [
        CGPoint(x: 386, y: 96),
        CGPoint(x: 426, y: 62),
        CGPoint(x: 466, y: 96),
    ], color: Palette.deepRed)
    for x in [218, 326, 500, 608] {
        rounded(ctx, x: CGFloat(x), y: 310, w: 42, h: 76, radius: 21, color: RGB(255, 255, 255, 0.70))
    }
    rounded(ctx, x: 392, y: 306, w: 70, h: 98, radius: 26, color: RGB(118, 82, 61))

    quadratic(ctx, from: CGPoint(x: 72, y: 366), control: CGPoint(x: 425, y: 232), to: CGPoint(x: 780, y: 366), color: RGB(159, 151, 133), width: 12)
    line(ctx, [CGPoint(x: 426, y: 62), CGPoint(x: 426, y: 34)], color: RGB(80, 91, 86), width: 4)
    polygon(ctx, points: [
        CGPoint(x: 430, y: 36),
        CGPoint(x: 500, y: 50),
        CGPoint(x: 430, y: 72),
    ], color: Palette.red)

    drawBottomMist(ctx)
}

private let heroes: [CityHero] = [
    CityHero(assetName: "HeroCityHanoi", fileName: "hero-city-hanoi.png", draw: drawHanoi),
    CityHero(assetName: "HeroCityHcmc", fileName: "hero-city-hcmc.png", draw: drawHcmc),
    CityHero(assetName: "HeroCityDanang", fileName: "hero-city-danang.png", draw: drawDanang),
    CityHero(assetName: "HeroCityHoian", fileName: "hero-city-hoian.png", draw: drawHoian),
    CityHero(assetName: "HeroCityHue", fileName: "hero-city-hue.png", draw: drawHue),
]

private func render(_ hero: CityHero, assetsRoot: URL) throws {
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw NSError(domain: "CityHero", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not create bitmap"])
    }

    guard let graphics = NSGraphicsContext(bitmapImageRep: rep) else {
        throw NSError(domain: "CityHero", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not create graphics context"])
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = graphics
    let ctx = graphics.cgContext
    ctx.interpolationQuality = .high
    ctx.setShouldAntialias(true)
    ctx.translateBy(x: 0, y: CGFloat(height))
    ctx.scaleBy(x: 1, y: -1)
    rect(ctx, x: 0, y: 0, w: CGFloat(width), h: CGFloat(height), color: Palette.page)
    hero.draw(ctx)
    NSGraphicsContext.restoreGraphicsState()

    guard let data = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "CityHero", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not encode PNG"])
    }

    let outputURL = assetsRoot
        .appendingPathComponent("\(hero.assetName).imageset")
        .appendingPathComponent(hero.fileName)
    try data.write(to: outputURL, options: .atomic)
    print("Rendered \(hero.assetName) -> \(outputURL.path)")
}

let repoRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let assetsRoot = repoRoot.appendingPathComponent("native-ios/Resources/Assets.xcassets")

for hero in heroes {
    try render(hero, assetsRoot: assetsRoot)
}
