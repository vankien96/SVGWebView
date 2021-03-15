//
//  ViewController.swift
//  SVGWebView
//
//  Created by Trương Văn Kiên on 03/03/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var svgWebView: SVGWebView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        svgWebView.removeAllMarker()
        svgWebView.clearAll()
    }
}

private extension ViewController {
    
    func setupUI() {
        svgWebView.delegate = self
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: SVGWebViewDelegate {
    
    func didTapPath(pathID: String) {
        svgWebView.clearAll()
        svgWebView.drawColor(pathID: pathID, color: UIColor.random.toHexString())
        guard let index = svgWebView.paths.firstIndex(where: { $0.id == pathID }) else { return }
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        guard let path = self.svgWebView.paths.first(where: { $0.id == pathID }) else { return }
        self.svgWebView.removeAllMarker()
        self.svgWebView.addPriceMarkerTo(path: path)
    }
    
    func didLoadPaths(paths: [SVGPath]) {
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return svgWebView.paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = svgWebView.paths[indexPath.row].id
        cell.selectedBackgroundView = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = svgWebView.paths[indexPath.row]
        svgWebView.zoomTo(path: path)
        svgWebView.clearAll()
        svgWebView.drawColor(pathID: path.id, color: UIColor.random.toHexString())
    }
}
