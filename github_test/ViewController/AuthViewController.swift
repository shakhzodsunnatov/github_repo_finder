//
//  AuthViewController.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import UIKit
import WebKit
import SnapKit

class AuthViewController: UIViewController {
    
    public var completionHandler: ((Bool) -> Void)?

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        
        guard let url = AuthManager.shared.signInUrl else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
 
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"})?.value else {
            return
        }
        
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(
            code: code) { [weak self] success in
                DispatchQueue.main.async {
                    self?.completionHandler?(success)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        
    }
}
