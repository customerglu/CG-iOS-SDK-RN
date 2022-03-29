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
            }
        }
    }
    
    private func setBannerView(height: Int, isAutoScrollEnabled: Bool, autoScrollSpeed: Int){
        self.frame.size.height = CGFloat(height)
        self.imgScrollView.frame.size.height = CGFloat(height)
        
        var dict = [String: AnyHashable]()
        dict["height"] = height
        dict["elementId"] = elementId

        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name("CUSTOMERGLU_Banner_Height").rawValue), object: self, userInfo: dict)
        
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
                var webView: WKWebView
                let xOrigin = self.imgScrollView.frame.size.width * CGFloat(i)
                webView = WKWebView(frame: CGRect(x: xOrigin, y: 0, width: self.imgScrollView.frame.size.width, height: self.imgScrollView.frame.size.height))
                webView.isUserInteractionEnabled = true
                webView.tag = i
                let urlStr = dict.url
                webView.load(URLRequest(url: URL(string: urlStr!)!))
                self.imgScrollView.addSubview(webView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                self.imgScrollView.addGestureRecognizer(tap)
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
        }
    }
}
