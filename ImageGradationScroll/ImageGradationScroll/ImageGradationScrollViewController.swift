//
//  ImageGradationScrollViewController.swift
//  ImageGradationScroll
//
//  Created by dongsuk Jo on 2020/01/29.
//  Copyright © 2020 dongsuk Jo. All rights reserved.
//

import UIKit
import WebKit

class ImageGradationScrollViewController: UIViewController ,UIScrollViewDelegate, WKNavigationDelegate {

    //스테이터스 바 흰색으로 설정
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    
    //이미지 뷰 값
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    //네비게이션 대신 사용하는 가장 위쪽의 뷰 값
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    
    //웹 뷰
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    //기타 값
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    //이미지 정보
    var dicDataInfo: Dictionary<String, Any> = Dictionary<String, Any>()
    var imageViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //타이틀을 설정한다.
        self.title = dicDataInfo["title"] as? String
        
        //네비게이션을 감춘다.
        self.navigationController?.isNavigationBarHidden = true
        
        //버튼 동그라미로 설정
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = backButton.bounds.width / 2.0
        
        //웹뷰에 델리게이트 설정
        webView.navigationDelegate = self
        
        //웹뷰에 리퀘스트를 보낸다.
        webView.load(URLRequest.init(url: URL(string: dicDataInfo["url"] as! String)!))
        
        //이미지를 불러온다.
        let image : UIImage = dicDataInfo["image"] as! UIImage
        imageView.image = image
        
        //이미지 사이즈를 가지고온다.
        let imageSize = image.size
        
        //이미지의 비율을 가지고 이미지뷰의 세로 높이를 계산해본다.
        //이미지 가로 : 이미지 세로 = 뷰 가로 : 뷰 세로
        //이미지 세로 * 뷰 가로 = 이미지 가로 * 뷰 세로
        //뷰 세로 = 이미지 세로 * 뷰 가로 / 이미지 가로
        imageViewHeight = imageSize.height * self.view.bounds.width / imageSize.width
        imageViewHeightConstraint.constant = imageViewHeight
        
        //이미지 뷰 아래에 투명한 그라데이션을 넣는다.
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.init(white: 0, alpha: 0).cgColor, UIColor.black.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - 버튼 이벤트
    
    @IBAction func backButtonTouch(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 웹뷰 델리게이트
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //컨텐츠의 높이를 찾아 높이를 알맞게 설정해준다.
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    self.webViewHeightConstraint.constant = height as! CGFloat
                    
                    //로딩 화면을 없엔다.
                    UIView.animate(withDuration: 0.25,
                                   animations: {
                                    self.loadingView.alpha = 0
                    },
                                   completion: { (Bool) in
                                    self.loadingView.isHidden = true
                    })
                })
            }
        })
    }
    
    // MARK: - 스크롤 델리게이트
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.y > 0)
        {
            if(scrollView.contentOffset.y < imageViewHeight - (view.bounds.height / 3))
            {
                //이미지 뷰의 높이보다 작게 스크롤 되면 이미지뷰의 높이를 줄이고, 줄이는 만큼 Y 를 띄워준다.
                imageViewTopConstraint.constant = scrollView.contentOffset.y
                imageViewHeightConstraint.constant = imageViewHeight - scrollView.contentOffset.y
                self.navigationController?.setNavigationBarHidden(true, animated: true);
                
                if(self.topViewTopConstraint.constant != 0)
                {
                    self.topViewTopConstraint.constant = 0
                    
                    UIView.animate(withDuration: 1.0) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
            else
            {
                //이미지 뷰의 높이보다 많이 스크롤 되면 네비게이션을 보여준다.
                imageViewTopConstraint.constant = imageViewHeight - (view.bounds.height / 3)
                imageViewHeightConstraint.constant = (view.bounds.height / 3)
                self.navigationController?.setNavigationBarHidden(false, animated: true);
                
                if(self.topViewTopConstraint.constant != -self.topView.bounds.height)
                {
                    self.topViewTopConstraint.constant = -self.topView.bounds.height
                    
                    UIView.animate(withDuration: 1.0) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        else
        {
            //기본값을 설정한다.
            imageViewTopConstraint.constant = 0
            imageViewHeightConstraint.constant = imageViewHeight
            self.navigationController?.setNavigationBarHidden(true, animated: true);
            
            if(self.topViewTopConstraint.constant != 0)
            {
                self.topViewTopConstraint.constant = 0
                
                UIView.animate(withDuration: 1.0) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}
