//
//  SVGWebView+Configuration.swift
//  GiantsSDK
//
//  Created by Trương Văn Kiên on 9/18/20.
//  Copyright © 2020 Est-Rouge. All rights reserved.
//

import Foundation
import WebKit

struct WebViewActionKey {
    static let log = "log"
    static let didTapPath = "didTapPath"
    static let transferBlocksInfo = "transferBlocksInfo"
}

extension SVGWebView {
    
    func getWebViewConfig() -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        let pref = WKPreferences()
        if #available(iOS 14, *) {
            let page = WKWebpagePreferences()
            page.preferredContentMode = .mobile
            config.defaultWebpagePreferences = page
        } else {
            pref.javaScriptCanOpenWindowsAutomatically = false
            pref.javaScriptEnabled = true
            config.preferences = pref
        }
        config.userContentController.add(self, name: WebViewActionKey.log)
        config.userContentController.add(self, name: WebViewActionKey.didTapPath)
        config.userContentController.add(self, name: WebViewActionKey.transferBlocksInfo)
        return config
    }
}

extension SVGWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case WebViewActionKey.log:
            print("JAVASCRIPT LOG: ", message.body)
        case WebViewActionKey.didTapPath:
            delegate?.didTapPath(pathID: (message.body as? String) ?? "")
        case WebViewActionKey.transferBlocksInfo:
            let paths = SVGPath.from(string: (message.body as? String) ?? "")
            self.paths = paths
            delegate?.didLoadPaths(paths: paths)
        default:
            break
        }
    }
}
