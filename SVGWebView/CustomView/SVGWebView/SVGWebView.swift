//
//  SVGWebView.swift
//  GiantsSDK
//
//  Created by Trương Văn Kiên on 9/18/20.
//  Copyright © 2020 Est-Rouge. All rights reserved.
//

import Foundation
import WebKit

protocol SVGWebViewDelegate: class {
    func didTapPath(pathID: String)
    func didLoadPaths(paths: [SVGPath])
}

class SVGWebView: UIView {
    
    var paths: [SVGPath] = []
    
    weak var delegate: SVGWebViewDelegate?
    
    private(set) lazy var webView: WKWebView = {
        let configuration = self.getWebViewConfig()
        let webView = WKWebView(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size), configuration: configuration)
        webView.contentMode = .scaleAspectFit
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.bouncesZoom = false
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.clipsToBounds = true
        webView.scrollView.clipsToBounds = true
        return webView
    }()
    
    private var isLoadedSVG = false
    private var markerView: MarkerView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func loadSVG(svgName: String) {
        guard let path = Bundle.main.path(forResource: svgName, ofType: "svg") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
        guard let rawSVG = String(data: data, encoding: .utf8) else { return }
        let loadSVG = "loadSVG('\(minifySVG(svg: rawSVG))')"
        webView.evaluateJavaScript(loadSVG, completionHandler: { _, _ in })
    }
}

private extension SVGWebView {
    
    func setupUI() {
        setupWebView()
    }
    
    func setupWebView() {
        self.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        loadWebView()
    }
    
    func loadWebView() {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "index", ofType: "html") else { return }
        let url = URL(fileURLWithPath: String(format: "%@", path))
        webView.load(URLRequest(url: url))
    }
}

// MARK: - WKNavigationDelegate
extension SVGWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !isLoadedSVG else { return }
        loadSVG(svgName: "princess")
        isLoadedSVG = true
    }
    
    private func minifySVG(svg: String) -> String {
        var newString = ""
        let myStrings = svg.components(separatedBy: .newlines)
        for string in myStrings {
            newString = "\(newString)\(string)"
        }
        return newString
    }
}

extension SVGWebView: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.resetMarkerFrameWhenZoom()
    }
}

extension SVGWebView {
    
    func drawColor(pathID: String, color: String) {
        guard !pathID.isEmpty, !color.isEmpty else { return }
        let script = "drawColor('\(pathID)', '\(color)')"
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
    
    func clearAll() {
        let script = "clearAll()"
        self.webView.evaluateJavaScript(script, completionHandler: nil)
    }
    
    func zoomToPath(path: SVGPath) {
        let center = path.rect
        let zoomScale = getZoomLevel(rect: center)
        zoom(rect: center, zoomScale: zoomScale)
    }
    
    func zoom(rect: CGRect, zoomScale: CGFloat, completion: (() -> Void)? = nil) {
        self.webView.scrollView.maximumZoomScale = zoomScale
        
        UIView.animate(withDuration: 0.35, delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
            self.webView.scrollView.zoom(to: rect, animated: false)
        }) { (_) in
            self.webView.scrollView.maximumZoomScale = 8.0
            completion?()
        }
    }
    
    func getZoomLevel(rect: CGRect) -> CGFloat {
        let padding: CGFloat = 16
        let scaleWidth = self.bounds.width / (rect.width + padding)
        let scaleHeight = self.bounds.height / (rect.height + padding)
        return min(scaleWidth, scaleHeight)
    }
}

extension SVGWebView {
    
    func addPriceMarkerTo(path: SVGPath, completion: (() -> Void)? = nil) {
        let zoomScale = webView.scrollView.zoomScale
        let center = CGPoint(x: path.rect.midX * zoomScale, y: path.rect.midY * zoomScale)
        
        let oldMarker = markerView as? PriceMarkerView
        
        let view = PriceMarkerView(arrowPosition: .bottom)
        
        view.updatePrice(price: path.id)
        webView.scrollView.addSubview(view)
        webView.scrollView.bringSubviewToFront(view)
        view.backgroundColor = .clear
        
        let visibleRect = CGRect(origin: webView.scrollView.contentOffset, size: webView.scrollView.bounds.size)
        var isInside = false
        if let oldMarkerCenter = oldMarker?.center, let oldFrame = oldMarker?.frame, visibleRect.intersects(oldFrame) {
            isInside = true
            view.center = oldMarkerCenter
        }
    
        oldMarker?.removeFromSuperview()
        
        var newFrame = view.frame
        
        newFrame.origin = view.adjustDisplayPoint(point: center)
        if isInside {
            UIView.animate(withDuration: 0.2) {
                view.frame = newFrame
                self.webView.scrollView.layoutIfNeeded()
            }
        } else {
            view.frame = newFrame
        }
        markerView = view
        webView.scrollView.scrollRectToVisible(CGRect(origin: center, size: CGSize(width: 1, height: 1)), animated: true)
        markerView?.path = path
        completion?()
    }
    
    func resetMarkerFrameWhenZoom() {
        guard let marker = markerView, marker.path != nil else { return }
        let pathRect = marker.path.rect
        var center: CGPoint
        let zoomScale = webView.scrollView.zoomScale
        if marker is PriceMarkerView {
            center = CGPoint(x: pathRect.midX * zoomScale, y: pathRect.midY * zoomScale)
        } else {
            center = CGPoint(x: pathRect.midX * zoomScale, y: pathRect.minY * zoomScale)
            center = webView.convert(center, to: webView.scrollView)
        }
        let origin = marker.adjustDisplayPoint(point: center)
        marker.frame.origin = origin
    }
    
    func removeAllMarker() {
        markerView?.removeFromSuperview()
        markerView = nil
        webView.scrollView.layoutIfNeeded()
    }
}
