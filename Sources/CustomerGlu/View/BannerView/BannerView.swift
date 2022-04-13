//
//  File.swift
//
//
//  Created by kapil on 1/2/22.
//

import UIKit
import Foundation
import WebKit

@IBDesignable public class BannerView: UIView, UIScrollViewDelegate {
    
    var view = UIView()
    var arrContent = [CGContent]()
    var elementID = ""

    @IBOutlet weak var imgScrollView: UIScrollView!

    @IBInspectable var elementId: String = "er" {
        didSet {
            self.elementID = elementId
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        xibSetup()
    }
        
    // MARK: - Nib handlers
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        self.frame.size.height = 0
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        imgScrollView.frame = bounds
        imgScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "BannerView", bundle: .module)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view!
    }
       
    public func reloadBannerView(element_id: String) {
        let bannerViews = CustomerGlu.entryPointdata.filter {
            $0.mobile.container.type == "BANNER" && $0.mobile.container.elementId == element_id
        }
        
        if bannerViews.count != 0 {
            let mobile = bannerViews[0].mobile!
            arrContent = [CGContent]()
            
            if mobile.content.count != 0 {
                for content in mobile.content {
                    arrContent.append(content)
                }
                
                self.setBannerView(height: Int(mobile.container.height)!, isAutoScrollEnabled: mobile.conditions.autoScroll, autoScrollSpeed: mobile.conditions.autoScrollSpeed)
                
                guard let topController = UIApplication.getTopViewController() else {
                    return
                }
                let className = NSStringFromClass(topController .classForCoder).components(separatedBy: ".").last!
                
                var actionType = ""
                if mobile.content[0].campaignId.count == 0 {
                    actionType = "WALLET"
                } else if mobile.content[0].campaignId.contains("http://") {
                    actionType = "CUSTOM_URL"
                } else {
                    actionType = "CAMPAIGN"
                }
              
                eventPublishNudge(pageName: className, nudgeId: mobile._id, actionName: "LOADED", actionType: actionType, openType: mobile.content[0].openLayout, campaignId: mobile.content[0].campaignId)
            }
        }
    }
    
    private func setBannerView(height: Int, isAutoScrollEnabled: Bool, autoScrollSpeed: Int){
        
        var dict = [String: AnyHashable]()
        dict["height"] = height
        dict["elementId"] = elementId
        
        let screenHeight = UIScreen.main.bounds.height
        let finalHeight = (Int(screenHeight) * height)/100
        
        if let constraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = CGFloat(finalHeight)
        } else {
            self.frame.size.height = CGFloat(finalHeight)
        }
           
        self.imgScrollView.frame.size.height = CGFloat(finalHeight)

        imgScrollView.delegate = self

        for i in 0..<arrContent.count {
            let dict = arrContent[i]
            if dict.type == "IMAGE" {
                var imageView: UIImageView
                let xOrigin = self.imgScrollView.frame.size.width * CGFloat(i)
                imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: self.imgScrollView.frame.size.width, height: self.imgScrollView.frame.size.height))
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
                let urlStr = dict.url
                imageView.downloadImage(urlString: urlStr!)
                imageView.contentMode = .scaleToFill
                self.imgScrollView.addSubview(imageView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                imageView.addGestureRecognizer(tap)
            } else {
                let containerView =  UIView()
                containerView.tag = i
                var webView: WKWebView
                let xOrigin = self.imgScrollView.frame.size.width * CGFloat(i)
                webView = WKWebView(frame: CGRect(x: xOrigin, y: 0, width: self.imgScrollView.frame.size.width, height: self.imgScrollView.frame.size.height))
                containerView.frame  = CGRect.init(x: xOrigin, y: 0, width: self.imgScrollView.frame.size.width, height: self.imgScrollView.frame.size.height)
                webView.isUserInteractionEnabled = false
                webView.tag = i
                let urlStr = dict.url
                webView.load(URLRequest(url: URL(string: urlStr!)!))
                containerView.addSubview(webView)
                self.imgScrollView.addSubview(containerView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                containerView.addGestureRecognizer(tap)
            }
        }
        self.imgScrollView.isPagingEnabled = true
        self.imgScrollView.bounces = false
        self.imgScrollView.showsVerticalScrollIndicator = false
        self.imgScrollView.showsHorizontalScrollIndicator = false
        self.imgScrollView.contentSize = CGSize(width: self.imgScrollView.frame.size.width * CGFloat(arrContent.count), height: self.imgScrollView.frame.size.height)
        
        // Timer in viewdidload()
        if isAutoScrollEnabled {
            Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollSpeed), target: self, selector: #selector(moveToNextImage), userInfo: nil, repeats: true)
        }
    }

    @objc func moveToNextImage() {
        let imgsCount: CGFloat = CGFloat(arrContent.count)
        let pageWidth: CGFloat = self.imgScrollView.frame.width
        let maxWidth: CGFloat = pageWidth * imgsCount
        let contentOffset: CGFloat = self.imgScrollView.contentOffset.x
        var slideToX = contentOffset + pageWidth
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        self.imgScrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: self.imgScrollView.frame.height), animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print(sender?.view?.tag ?? 0)
        let dict = arrContent[tag]
        if dict.campaignId != nil {
            CustomerGlu.getInstance.loadCampaignById(campaign_id: dict.campaignId)
            
            guard let topController = UIApplication.getTopViewController() else {
                return
            }
            let className = NSStringFromClass(topController .classForCoder).components(separatedBy: ".").last!
            
            var actionType = ""
            if dict.campaignId.count == 0 {
                actionType = "WALLET"
            } else if dict.campaignId.contains("http://") {
                actionType = "CUSTOM_URL"
            } else {
                actionType = "CAMPAIGN"
            }
          
            eventPublishNudge(pageName: className, nudgeId: dict._id, actionName: "OPEN", actionType: actionType, openType: dict.openLayout, campaignId: dict.campaignId)
        }
    }
    
    private func eventPublishNudge(pageName: String, nudgeId: String, actionName: String, actionType: String, openType: String, campaignId: String) {
        var eventInfo = [String: AnyHashable]()
        eventInfo[APIParameterKey.nudgeType] = "BANNER"

        eventInfo[APIParameterKey.pageName] = pageName
        eventInfo[APIParameterKey.nudgeId] = nudgeId
        eventInfo[APIParameterKey.actionName] = actionName
        eventInfo[APIParameterKey.actionType] = actionType
        eventInfo[APIParameterKey.openType] = openType
        eventInfo[APIParameterKey.campaignId] = campaignId
        
        ApplicationManager.publishNudge(eventNudge: eventInfo) { success, _ in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
}
