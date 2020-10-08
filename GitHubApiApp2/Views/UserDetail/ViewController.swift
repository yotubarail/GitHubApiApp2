//
//  ViewController.swift
//  GitHubApiApp2
//
//  Created by 滝浪翔太 on 2020/10/06.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    //MARK: - Vars
    var webView: WKWebView!
    var userUrl: String!
    var titleText: String!

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        
        webView.navigationDelegate = self
        
        openUrl(urlString: userUrl)

        navigationItem.title = titleText
    }
    
    //MARK: - Functions
    func openUrl(urlString: String) {
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request as URLRequest)
    }
    
    //MARK: - Navigation Delegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        showProgress()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        hideProgress()
    }
}

