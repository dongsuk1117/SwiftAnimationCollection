//
//  NotificationTopViewController.swift
//  TopNotification
//
//  Created by dongsuk Jo on 2020/07/08.
//  Copyright © 2020 dongsuk Jo. All rights reserved.
//

import UIKit
import AudioToolbox

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var _notificationViewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var _notificationView: UIView!
    
    var _notificationTopViewTop: NSLayoutConstraint?
    var _timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /**
     알림 화면을 초기화 하는 함수.
     주의 : viewDidAppear 이후에 호출해야 UIWindow 가 찾아진다.
     */
    func addSubViewAtWindow() {
        
        //자신의 오토레이아웃을 코드로 설정 가능하게 한다.
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        //라운드 설정
        _notificationView.layer.cornerRadius = 5
        _notificationView.clipsToBounds = true
        
        //테두리 처리
        _notificationView.layer.borderColor = UIColor.black.cgColor
        _notificationView.layer.borderWidth = 0.5
        
        //알림 화면의 초기 설정을 한다.
        _notificationView.alpha = 0
        _notificationViewConstraintTop.constant = -109
        
        //윈도우에 추가한다.
        let window: UIWindow? = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.addSubview(self.view)
        
        //윈도우에 오토레이아웃을 설정한다.
        _notificationTopViewTop = NSLayoutConstraint.init(item: self.view!,
                                                          attribute: .top,
                                                          relatedBy: .equal,
                                                          toItem: window!,
                                                          attribute: .top,
                                                          multiplier: 1,
                                                          constant: -109)
        
        window?.addConstraint(_notificationTopViewTop!)
        
        window?.addConstraint(NSLayoutConstraint.init(item: self.view!,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: window!,
                                                      attribute: .left,
                                                      multiplier: 1,
                                                      constant: 0))
        
        window?.addConstraint(NSLayoutConstraint.init(item: self.view!,
                                                      attribute: .right,
                                                      relatedBy: .equal,
                                                      toItem: window!,
                                                      attribute: .right,
                                                      multiplier: 1,
                                                      constant: 0))
        
        
        self.view?.addConstraint(NSLayoutConstraint.init(item: self.view!,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .height,
                                                         multiplier: 1,
                                                         constant: 109))
        
        //호출 리슨어를 등록한다.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appNotification(aNotification:)),
                                               name: NSNotification.Name.init("app_notification"),
                                               object: nil)
        
    }
    
    /**
     알림 화면 노출 Notification 리슨어 함수
     */
    @objc func appNotification(aNotification: NSNotification) {
        
        //진동 알림
        if #available(iOS 10,*) {
            generator(type: 2)
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        //타이머 있다면 초기화
        if _timer != nil {
            _timer?.invalidate()
            _timer = nil
        }
        
        //타이머 설정
        _timer = Timer.scheduledTimer(timeInterval: 1.0,
                                      target: self,
                                      selector: #selector(appNotificationClose(aTimer:)),
                                      userInfo: nil,
                                      repeats: false)
        
        //애니메이션으로 알럿 화면 보여주기
        _notificationTopViewTop?.constant = 0
        _notificationViewConstraintTop.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self._notificationView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     알림 화면을 닫는 타이머 호출 함수.
     */
    @objc func appNotificationClose(aTimer: Timer) {
        
        self._notificationViewConstraintTop.constant = -109
        
        UIView.animate(withDuration: 0.25,
                       animations: {
                        self._notificationView.alpha = 0
                        self.view.layoutIfNeeded()
        }) { (completion: Bool) in
            self._notificationTopViewTop?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     햅틱 엔진을 이용한 진동 함수.
     */
    func generator(type: Int) {
        
        switch type {
        case 1:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case 2:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case 3:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case 4:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case 5:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case 6:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        default:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
