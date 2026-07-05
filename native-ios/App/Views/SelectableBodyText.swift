import SwiftUI
import UIKit

struct SelectableBodyText: UIViewRepresentable {
    enum TextStyle {
        case body
        case subheadline

        var font: UIFont {
            switch self {
            case .body:
                return .preferredFont(forTextStyle: .body)
            case .subheadline:
                return .preferredFont(forTextStyle: .subheadline)
            }
        }
    }

    let text: String
    var textStyle: TextStyle = .body
    var color: UIColor = .secondaryLabel
    var lineSpacing: CGFloat = 3
    var definitions: [PhraseInlineDefinition] = []
    var onOpenDefinition: (PhraseInlineDefinition) -> Void = { _ in }

    func makeCoordinator() -> Coordinator {
        Coordinator(definitions: definitions, onOpenDefinition: onOpenDefinition)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = context.coordinator
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        context.coordinator.definitions = definitions
        context.coordinator.onOpenDefinition = onOpenDefinition
        textView.attributedText = attributedText
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.systemRed,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        let width = proposal.width ?? uiView.bounds.width
        guard width > 0 else {
            return nil
        }

        let size = uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return CGSize(width: width, height: ceil(size.height))
    }

    private var attributedText: NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: textStyle.font,
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]
        )

        for definition in definitions {
            let ranges = (text as NSString).ranges(
                of: definition.vietnamese,
                options: [.caseInsensitive, .diacriticInsensitive]
            )

            for range in ranges {
                let definitionURL = URL(string: "speaklocal-definition://\(definition.id)")!
                attributed.addAttributes(
                    [
                        .font: textStyle.font.weighted(.semibold),
                        .foregroundColor: UIColor.systemRed,
                        .underlineStyle: NSUnderlineStyle.patternDot.rawValue,
                        .underlineColor: UIColor.systemRed.withAlphaComponent(0.75),
                        .link: definitionURL
                    ],
                    range: range
                )
            }
        }

        return attributed
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var definitions: [PhraseInlineDefinition]
        var onOpenDefinition: (PhraseInlineDefinition) -> Void

        init(
            definitions: [PhraseInlineDefinition],
            onOpenDefinition: @escaping (PhraseInlineDefinition) -> Void
        ) {
            self.definitions = definitions
            self.onOpenDefinition = onOpenDefinition
        }

        func textView(
            _ textView: UITextView,
            primaryActionFor textItem: UITextItem,
            defaultAction: UIAction
        ) -> UIAction? {
            guard
                case let .link(url) = textItem.content,
                url.scheme == "speaklocal-definition",
                let id = url.host,
                let definition = definitions.first(where: { $0.id == id })
            else {
                return defaultAction
            }

            return UIAction { [weak self] _ in
                self?.onOpenDefinition(definition)
            }
        }
    }
}

private extension NSString {
    func ranges(
        of searchString: String,
        options: NSString.CompareOptions
    ) -> [NSRange] {
        guard !searchString.isEmpty else {
            return []
        }

        var ranges: [NSRange] = []
        var searchRange = NSRange(location: 0, length: length)

        while searchRange.location < length {
            let foundRange = range(of: searchString, options: options, range: searchRange)
            if foundRange.location == NSNotFound {
                break
            }

            ranges.append(foundRange)

            let nextLocation = foundRange.location + foundRange.length
            searchRange = NSRange(location: nextLocation, length: length - nextLocation)
        }

        return ranges
    }
}

private extension UIFont {
    func weighted(_ weight: UIFont.Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: .body)
        let descriptor = fontDescriptor.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ])
        return metrics.scaledFont(for: UIFont(descriptor: descriptor, size: pointSize))
    }
}
