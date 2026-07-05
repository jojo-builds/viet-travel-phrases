import Foundation

struct TopAdminMoreMenuItem: Equatable, Identifiable {
    let title: String
    let systemImage: String
    let url: URL

    var id: String { title }

    static let goLiveItems: [TopAdminMoreMenuItem] = [
        TopAdminMoreMenuItem(
            title: "Send Feedback",
            systemImage: "message",
            url: URL(string: "mailto:feedback@jayopsai.com")!
        ),
        TopAdminMoreMenuItem(
            title: "Contact Support",
            systemImage: "envelope",
            url: URL(string: "https://speaklocal.app/feedback/")!
        ),
        TopAdminMoreMenuItem(
            title: "Privacy Policy",
            systemImage: "shield",
            url: URL(string: "https://speaklocal.app/privacy/")!
        ),
        TopAdminMoreMenuItem(
            title: "Terms of Use",
            systemImage: "doc.text",
            url: URL(string: "https://speaklocal.app/terms/")!
        )
    ]
}
