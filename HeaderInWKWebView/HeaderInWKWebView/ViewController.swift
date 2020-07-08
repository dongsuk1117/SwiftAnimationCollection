//
//  ViewController.swift
//  HeaderInWKWebView
//
//  Created by dongsuk Jo on 2020/05/11.
//  Copyright © 2020 dongsuk Jo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var _inView: UIView?
    var _inViewheightConstraint: NSLayoutConstraint?
    var _inViewTopConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var _webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //웹을 표시한다.
        let url: URL = URL.init(string: "https://github.com/dongsuk1117/HeaderInWKWebView")!
        let request: URLRequest = URLRequest.init(url: url)
        
        _webView.load(request)
        
        //넣을 뷰를 만든다.
        _inView = UIView.init(frame: CGRect.zero)
        _inView!.backgroundColor = UIColor.red
        _inView!.translatesAutoresizingMaskIntoConstraints = false
        
        //뷰를 넣는다.
        _webView.scrollView.addSubview(_inView!)
        
        //레이아웃을 설정한다.
        _webView.scrollView.addConstraint(NSLayoutConstraint.init(item: _inView!,
                                                                  attribute: .leftMargin,
                                                                  relatedBy: .equal,
                                                                  toItem: _webView.scrollView,
                                                                  attribute: .leftMargin,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0))
        
        _webView.scrollView.addConstraint(NSLayoutConstraint.init(item: _inView!,
                                                                  attribute: .width,
                                                                  relatedBy: .equal,
                                                                  toItem: _webView.scrollView,
                                                                  attribute: .width,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0))
        
        //세로값은 변경 하기 위해 저장한다.
        _inViewheightConstraint = NSLayoutConstraint.init(item: _inView!,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1.0,
                                                          constant: 0.0)
        
        _inView!.addConstraint(_inViewheightConstraint!)
        
        //높이값도 변경해야 하기에 저장한다.
        _inViewTopConstraint = NSLayoutConstraint.init(item: _inView!,
                                                       attribute: .topMargin,
                                                       relatedBy: .equal,
                                                       toItem: _webView.scrollView,
                                                       attribute: .topMargin,
                                                       multiplier: 1.0,
                                                       constant: 0.0)
        
        _webView.scrollView.addConstraint(_inViewTopConstraint!)
        
        //넣은 뷰의 높이만큼 내용 화면을 내린다.
        setWebViewHeaderHeight(height: 100.0);
    }
    
    func setWebViewHeaderHeight(height: CGFloat) {
        
        _inViewheightConstraint?.constant = height
        _inViewTopConstraint?.constant = -height
        _webView.scrollView.contentInset = UIEdgeInsets.init(top: height, left: 0, bottom: 0, right: 0)
    }
}

