//
//  ViewController.swift
//  TopNotification
//
//  Created by dongsuk Jo on 2020/07/08.
//  Copyright © 2020 dongsuk Jo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var _notificationView: NotificationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let storyboard = UIStoryboard(name: Bundle.main.infoDictionary?["UIMainStoryboardFile"] as! String, bundle: Bundle.main)
        _notificationView = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController
        _notificationView?.addSubViewAtWindow()
    }
    
    @IBAction func callNotificationButtonTouch(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init("app_notification"), object: nil)
    }
}

