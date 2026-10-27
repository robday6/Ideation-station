import SwiftUI
import WebKit

// Ideate for Mac: a native window around the web app in ../index.html.
// The page is bundled into the app at build time (see build.sh) and loaded from disk,
// so it works offline (apart from web fonts) and keeps its saved data between launches.

extension Notification.Name {
    static let ideateCommand = Notification.Name("IdeateCommand")
}

enum IdeateCommand: String {
    case reload, zoomIn, zoomOut, actualSize
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

@main
struct IdeateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Window("Ideate", id: "main") {
            IdeateWebView()
                .frame(minWidth: 720, minHeight: 560)
                .background(Color(red: 0.05, green: 0.05, blue: 0.05))
        }
        .defaultSize(width: 1280, height: 860)
        .commands {
            CommandGroup(after: .toolbar) {
                Button("Actual Size") { send(.actualSize) }.keyboardShortcut("0")
                Button("Zoom In") { send(.zoomIn) }.keyboardShortcut("+")
                Button("Zoom Out") { send(.zoomOut) }.keyboardShortcut("-")
                Divider()
                Button("Reload") { send(.reload) }.keyboardShortcut("r")
            }
        }
    }

    private func send(_ command: IdeateCommand) {
        NotificationCenter.default.post(name: .ideateCommand, object: command.rawValue)
    }
}

struct IdeateWebView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default() // persistent, so saved sets and decks survive restarts
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsMagnification = true
        webView.allowsBackForwardNavigationGestures = false
        webView.setValue(false, forKey: "drawsBackground") // no white flash before the page paints
        if #available(macOS 13.3, *) { webView.isInspectable = true } // right-click > Inspect Element

        context.coordinator.attach(webView)
        context.coordinator.loadPage()
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        private weak var webView: WKWebView?
        private var observer: NSObjectProtocol?

        func attach(_ webView: WKWebView) {
            self.webView = webView
            observer = NotificationCenter.default.addObserver(forName: .ideateCommand, object: nil, queue: .main) { [weak self] note in
                guard let raw = note.object as? String, let command = IdeateCommand(rawValue: raw) else { return }
                self?.handle(command)
            }
        }

        deinit { if let observer { NotificationCenter.default.removeObserver(observer) } }

        func loadPage() {
            guard let webView,
                  let page = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "web") else {
                webView?.loadHTMLString("<body style='font:16px -apple-system;color:#ddd;background:#111;padding:40px'>Ideate couldn't find its page. Rebuild with mac/build.sh.</body>", baseURL: nil)
                return
            }
            webView.loadFileURL(page, allowingReadAccessTo: page.deletingLastPathComponent())
        }

        private func handle(_ command: IdeateCommand) {
            guard let webView else { return }
            switch command {
            case .reload: webView.reload()
            case .zoomIn: webView.pageZoom = min(webView.pageZoom + 0.1, 2.0)
            case .zoomOut: webView.pageZoom = max(webView.pageZoom - 0.1, 0.6)
            case .actualSize: webView.pageZoom = 1.0
            }
        }

        // Links to the web open in the default browser; the app itself stays on the bundled page.
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else { return decisionHandler(.cancel) }
            if url.isFileURL || url.scheme == "about" || url.scheme == "blob" || url.scheme == "data" {
                decisionHandler(.allow)
            } else if navigationAction.targetFrame?.isMainFrame == false {
                decisionHandler(.allow) // embedded frames
            } else {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
            }
        }

        // target="_blank" and window.open
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url, !url.isFileURL { NSWorkspace.shared.open(url) }
            return nil
        }

        // <input type="file"> (Judge: add screens)
        func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters,
                     initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = parameters.allowsMultipleSelection
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
            if let window = webView.window {
                panel.beginSheetModal(for: window) { completionHandler($0 == .OK ? panel.urls : nil) }
            } else {
                completionHandler(panel.runModal() == .OK ? panel.urls : nil)
            }
        }

        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            let alert = NSAlert()
            alert.messageText = message
            alert.runModal()
            completionHandler()
        }

        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            let alert = NSAlert()
            alert.messageText = message
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            completionHandler(alert.runModal() == .alertFirstButtonReturn)
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) { webView.reload() }
    }
}
