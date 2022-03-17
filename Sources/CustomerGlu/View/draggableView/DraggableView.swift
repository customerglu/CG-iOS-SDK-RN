//
//  File.swift
//  
//
//  Created by kapil on 02/02/22.
//

import Foundation
import UIKit

class DraggableView: UIView {
    
//    static let shared = DraggableView()
    
    var panGesture = UIPanGestureRecognizer()
    var lblText = UILabel()
    var imgView = UIImageView()
    var floatInfo: CGData?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        configure()
    }
    
    init(btnInfo: CGData) {
        floatInfo = btnInfo
        
        let height: Int = Int(btnInfo.mobile.container.height)!
        let width: Int = Int(btnInfo.mobile.container.width)!
                
        if btnInfo.mobile.container.position == "BOTTOM-LEFT" {
            super.init(frame: CGRect(x: 10, y: Int(UIScreen.main.bounds.height) - (height + 20), width: width, height: height))
        } else if btnInfo.mobile.container.position == "BOTTOM-RIGHT" {
            super.init(frame: CGRect(x: Int(UIScreen.main.bounds.maxX) - 110, y: Int(UIScreen.main.bounds.height) - (height + 20), width: width, height: height))
        } else {
            super.init(frame: CGRect(x: Int(UIScreen.main.bounds.midX) - 50, y: Int(UIScreen.main.bounds.height) - (height + 20), width: width, height: height))
        }
      
        backgroundColor = UIColor.clear
        self.isAccessibilityElement = true
        self.layer.name = btnInfo.mobile.container.elementId

        imgView.frame = self.bounds
        imgView.downloadImage(urlString: btnInfo.mobile.content[0].url)
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        self.addSubview(imgView)
        configure()
    }
    
    public func setupDraggableView(){
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    public func setupView(){
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.red
        self.backgroundColor = .red
        configure()
    }
    
    private func configure() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        self.removeFromSuperview()
        if floatInfo?.mobile.content[0].openLayout == "FULL-DEFAULT" {
            CustomerGlu.getInstance.presentToCustomerWebViewController(nudge_url: (floatInfo?.mobile.content[0].url)!, page_type: Constants.FULL_SCREEN_NOTIFICATION, backgroundAlpha: 0.5)
        }
    }
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        self.bringSubviewToFront(self)
        let translation = sender.translation(in: self)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
    }
}
