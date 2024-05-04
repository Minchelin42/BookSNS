//
//  BookWebViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/04.
//

import UIKit
import WebKit
import SnapKit

class BookWebViewController: UIViewController {
    
    let bookWebView = WKWebView()
    
    var urlString = ""
    var bookTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(bookWebView)
        view.backgroundColor = .white
        bookWebView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        
        
        navigationItem.title = "\(bookTitle)"
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            bookWebView.load(request)
        }
    }

}
