//
//  File.swift
//
//
//  Created by kapil on 1/2/22.
//

import UIKit
import Foundation
import WebKit

public class BannerView: UIView, UIScrollViewDelegate {
    
    var view = UIView()
    var arrContent = [CGContent]()
    private var code = true

    @IBOutlet weak private var imgScrollView: UIScrollView!

    @IBInspectable var elementId: String? {
        didSet {
        }
    }
        
    public init(frame: CGRect, elementId: String) {
        //CODE
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.elementId = elementId
        code = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        // XIB
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        code = false
    }

    public override func layoutSubviews() {
        if imgScrollView != nil {
            imgScrollView.removeFromSuperview()
        }
        view.removeFromSuperview()
        xibSetup()
    }
    
    // MARK: - Nib handlers
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        imgScrollView.frame = bounds
        imgScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        reloadBannerView(element_id: self.elementId ?? "")
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "BannerView", bundle: .module)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view!
    }
       
    public func reloadBannerView(element_id: String) {
                
        let bannerViews = CustomerGlu.entryPointdata.filter {
            $0.mobile.container.type == "BANNER" && $0.mobile.container.bannerId == element_id
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
                } else if mobile.content[0].campaignId.contains("http://") || mobile.content[0].campaignId.contains("https://"){
                    actionType = "CUSTOM_URL"
                } else {
                    actionType = "CAMPAIGN"
                }
              
                eventPublishNudge(pageName: className, nudgeId: mobile._id, actionName: "LOADED", actionType: actionType, openType: mobile.content[0].openLayout, campaignId: mobile.content[0].campaignId)
            }
        } else {
            if code == true {
                self.frame.size.height = CGFloat(0)
                self.imgScrollView.frame.size.height = CGFloat(0)
            } else {
                if let heightconstraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
                    heightconstraint.constant = CGFloat(0)
                    self.imgScrollView.frame.size.height = CGFloat(0)
                } else {
                    self.frame.size.height = CGFloat(0)
                    self.imgScrollView.frame.size.height = CGFloat(0)
                }
            }
        }
    }
    
    private func setBannerView(height: Int, isAutoScrollEnabled: Bool, autoScrollSpeed: Int){
        
        let screenWidth = self.frame.size.width
        let screenHeight = UIScreen.main.bounds.height
        let finalHeight = (Int(screenHeight) * height)/100
        
        if code == true {
            self.frame.size.height = CGFloat(finalHeight)
            self.imgScrollView.frame.size.height = CGFloat(finalHeight)
        } else {
            if let heightconstraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
                heightconstraint.constant = CGFloat(finalHeight)
                self.imgScrollView.frame.size.height = CGFloat(heightconstraint.constant)
            } else {
                self.frame.size.height = CGFloat(finalHeight)
                self.imgScrollView.frame.size.height = CGFloat(finalHeight)
            }
        }

        imgScrollView.delegate = self

        for i in 0..<arrContent.count {
            let dict = arrContent[i]
            if dict.type == "IMAGE" {
                var imageView: UIImageView
                let xOrigin = screenWidth * CGFloat(i)
               
                imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: screenWidth, height: self.imgScrollView.frame.size.height))
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
                let xOrigin = screenWidth * CGFloat(i)
                webView = WKWebView(frame: CGRect(x: xOrigin, y: 0, width: screenWidth, height: self.imgScrollView.frame.size.height))
                containerView.frame  = CGRect.init(x: xOrigin, y: 0, width: screenWidth, height: self.imgScrollView.frame.size.height)
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
        self.imgScrollView.contentSize = CGSize(width: screenWidth * CGFloat(arrContent.count), height: self.imgScrollView.frame.size.height)
        
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
        let dict = arrContent[sender?.view?.tag ?? 0]
        if dict.campaignId != nil {
            CustomerGlu.getInstance.loadCampaignById(campaign_id: dict.campaignId)
                        
            var actionType = ""
            if dict.campaignId.count == 0 {
                actionType = "WALLET"
            } else if dict.campaignId.contains("http://") || dict.campaignId.contains("https://"){
                actionType = "CUSTOM_URL"
            } else {
                actionType = "CAMPAIGN"
            }
          
            eventPublishNudge(pageName: CustomerGlu.getInstance.activescreenname, nudgeId: dict._id, actionName: "OPEN", actionType: actionType, openType: dict.openLayout, campaignId: dict.campaignId)
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
