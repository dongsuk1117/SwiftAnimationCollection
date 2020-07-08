//
//  ViewController.swift
//  ImageGradationScroll
//
//  Created by dongsuk Jo on 2020/01/29.
//  Copyright © 2020 dongsuk Jo. All rights reserved.
//

import UIKit

class MainViewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //스테이터스 바 흰색으로 설정
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrList: Array<Dictionary<String, Any>> = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNeedsStatusBarAppearanceUpdate()
        
        //기본 자료를 설정한다.
        var dicTemp: Dictionary<String, Any> = Dictionary<String, Any>()
        dicTemp["title"] = "겨울왕국 2"
        dicTemp["url"] = "https://namu.wiki/w/%EA%B2%A8%EC%9A%B8%EC%99%95%EA%B5%AD%202"
        dicTemp["image"] = UIImage.init(named: "image1.jpg")
        arrList.append(dicTemp)
        
        dicTemp = Dictionary<String, Any>()
        dicTemp["title"] = "블랙머니"
        dicTemp["url"] = "https://namu.wiki/w/%EB%B8%94%EB%9E%99%EB%A8%B8%EB%8B%88(%EC%98%81%ED%99%94)"
        dicTemp["image"] = UIImage.init(named: "image2.jpg")
        arrList.append(dicTemp)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //네비게이션을 보여준다.
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //호출 이벤트 확인
        if segue.identifier == "ShowImageGradationScrollView"
        {
            //호출되는 클레스 확인 후 값 설정
            if let destinationVC: ImageGradationScrollViewController = segue.destination as? ImageGradationScrollViewController {
                
                destinationVC.dicDataInfo = sender as! Dictionary<String, Any>
            }
        }
    }
    
    // MARK: - 컬렉션 뷰 델리게이트
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.size.width / 2, height: view.bounds.size.width / 2 * 1.35)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCollectionViewCell", for: indexPath) as! MainViewCollectionViewCell
        let dicTemp: Dictionary<String, Any> = arrList[indexPath.row]
        
        cell.imageView.image = dicTemp["image"] as? UIImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dicTemp: Dictionary<String, Any> = arrList[indexPath.row]
        
        performSegue(withIdentifier: "ShowImageGradationScrollView", sender: dicTemp)
    }
}

