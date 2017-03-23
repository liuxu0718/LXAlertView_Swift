//
//  LXAlertView.swift
//  LXAlerView_Swift
//
//  Created by 刘旭 on 3/23/17.
//  Copyright © 2017 刘旭. All rights reserved.
//

import UIKit

enum LXAlertViewType:Int {
    case Default = 0, Select, TextField, Land
}


class LXAlertView: UIView {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let alertWidth: CGFloat = 250
    let alertHeight: CGFloat = 175

    var type:LXAlertViewType = .Default
    var delegate: LXAlertViewDelegate?
    
    lazy var overlayView: UIView = {
        let view = UIView.init(frame: self.appRootViewController().view.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0.6
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.alertWidth, height: self.alertHeight))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.backgroundView.frame.size.width, height: self.backgroundView.frame.size.height - 45))
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var midTextField: UITextField = {
        let textField = UITextField.init(frame: CGRect.init(x: 0, y: (self.backgroundView.frame.size.height - 45) / 2, width: self.backgroundView.frame.size.width - 50, height: 30))
        textField.center = CGPoint.init(x: self.backgroundView.center.x, y: textField.center.y)
        textField.textColor = UIColor.black
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.placeholder = "hello world"
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.backgroundView.frame.size.width / 2, y: self.backgroundView.frame.size.height - 45, width: self.backgroundView.frame.size.width / 2, height: 45))
        button.backgroundColor = UIColor.black
        button.tag = 1
        button.addTarget(self, action: #selector(buttonAction(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: self.backgroundView.frame.size.height - 45, width: self.backgroundView.frame.size.width / 2, height: 45))
        button.backgroundColor = UIColor.black
        button.tag = 2
        button.addTarget(self, action: #selector(buttonAction(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    

    
    //loadUI
    init(frame: CGRect, title: String, type: LXAlertViewType) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.type = type
        
        self.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.titleLabel)
        self.backgroundView.addSubview(self.midTextField)
        self.backgroundView.addSubview(self.confirmButton)
        self.backgroundView.addSubview(self.closeButton)

        self.titleLabel.text = title
        
        switch self.type {
        case .Default, .Land:
            self.closeButton.isHidden = true
            self.midTextField.isHidden = true
            self.confirmButton.setImage(UIImage.init(named: "alert_confirm"), for: UIControlState.normal)
            self.confirmButton.frame = CGRect.init(x: 0, y: self.backgroundView.frame.size.height - 45, width: self.backgroundView.frame.size.width, height: 45)
            break
        case .Select:
            self.closeButton.isHidden = false
            self.midTextField.isHidden = true
            self.closeButton.setTitle("取消", for: UIControlState.normal)
            self.confirmButton.setTitle("确认", for: UIControlState.normal)
            break
        case .TextField:
            self.closeButton.isHidden = false
            self.midTextField.isHidden = false
            self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: self.backgroundView.frame.size.width, height: (self.backgroundView.frame.size.height - 45) / 2);
            self.closeButton.setTitle("取消", for: UIControlState.normal)
            self.confirmButton.setTitle("确认", for: UIControlState.normal)
            break
        }
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func buttonAction(_ button: UIButton) {
        self.removeFromSuperview()
        self.delegate?.lxAlertView(buttonIndex: button.tag, with: self.midTextField.text!)
    }
    
    //MARK: - 展示
    func show() {
        if self.type == .Land {
            self.frame = CGRect.init(x: (self.screenWidth - self.alertWidth) * 0.5, y: 0, width: self.alertWidth, height: self.alertHeight)
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect.init(x: (self.screenWidth - self.alertWidth) * 0.5, y: (self.screenHeight - self.alertHeight) * 0.5, width: self.alertWidth, height: self.alertHeight)
            })
        } else {
            self.frame = CGRect.init(x: (self.screenWidth - self.alertWidth) * 0.5, y: (self.screenHeight - self.alertHeight) * 0.5, width: self.alertWidth, height: self.alertHeight)
            self.setStartState()
        }
        self.appRootViewController().view.addSubview(self)
    }
    
    //MARK: - 动画开始和结束
    //可根据需求自己替换新的
    func setStartState() {
        self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
    }
    
    func setEndState() {
        self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
    }
    
    //MARK: - 核心方法
    override func willMove(toSuperview newSuperview: UIView?) {
        if (newSuperview == nil) {
            return
        }
        self.appRootViewController().view.addSubview(self.overlayView)
        UIView.animate(withDuration: 0.3, delay: 0, options: .layoutSubviews, animations: { 
            self.setEndState()
        }) { (Bool) in
            super.willMove(toSuperview: newSuperview)
        }
    }
    
    //MARK: - 获取根视图控制器
    func appRootViewController() -> UIViewController {
        var appRootVC = UIApplication.shared.keyWindow?.rootViewController
        while ((appRootVC?.presentedViewController) != nil) {
            appRootVC = appRootVC?.presentedViewController
        }
        return appRootVC!
    }
    
    //MARK: - 重写remove
    override func removeFromSuperview() {
        self.overlayView .removeFromSuperview()
        if self.type == .Land {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect.init(x: (self.screenWidth - self.alertWidth) * 0.5, y: self.screenHeight, width: self.alertWidth, height: self.alertHeight)
                self.alpha = 0
            }, completion: { (Bool) in
                super.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .layoutSubviews, animations: {
                self.setStartState()
            }) { (Bool) in
                super.removeFromSuperview()
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - textField代理
extension LXAlertView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

protocol LXAlertViewDelegate {
    func lxAlertView(buttonIndex:Int, with object:String)
}

