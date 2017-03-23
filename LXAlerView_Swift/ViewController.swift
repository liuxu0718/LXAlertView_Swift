//
//  ViewController.swift
//  LXAlerView_Swift
//
//  Created by 刘旭 on 3/23/17.
//  Copyright © 2017 刘旭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let array = ["AlertDefault", "AlertSelect", "AlertTextField", "AlertLand"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for index in 0..<array.count {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40));
            button.center = CGPoint.init(x: self.view.center.x, y: CGFloat(50 * (index + 3)))
            button.tag = index
            button.backgroundColor = UIColor.gray
            button .addTarget(self, action: #selector(buttonAction(_:)), for: UIControlEvents.touchUpInside)
            button .setTitle(array[index], for: UIControlState.normal)
            self.view.addSubview(button)
        }
    }
    
    func buttonAction(_ button:UIButton) {
        let alert = LXAlertView.init(frame:self.view.bounds, title: (button.titleLabel?.text)!, type: LXAlertViewType(rawValue: button.tag)!)
        alert.delegate = self;
        alert.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: LXAlertViewDelegate {
    func lxAlertView(buttonIndex: Int, with object: String) {
        if buttonIndex == 1 {
            print("ok🐒\(object)")
        } else {
            print("cancel🐒")
        }
    }
}

