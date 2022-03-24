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
    var isAutoScroll = false
    var autoScrollSpeed = 0
    var elementID = ""
    var viewHeight = 0
    
    @IBOutlet weak var imgScrollView: UIScrollView!
    var sliderImagesArray = NSMutableArray()
    var subViewArray = [CGContent]()
    
    @IBInspectable var elementId: String = "er" {
        didSet {
            self.elementID = elementId
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        xibSetup()
    }
    
    func configure() {
        self.frame.size.height = CGFloat(viewHeight)
        self.imgScrollView.frame.size.height = CGFloat(viewHeight)
        
        var dict = [String: AnyHashable]()
        dict["height"] = viewHeight
        dict["elementId"] = elementId

        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name("CUSTOMERGLU_Banner_Height").rawValue), object: self, userInfo: dict)
        
        imgScrollView.delegate = self
        for i in 0..<subViewArray.count {
            let dict = subViewArray[i]
            if dict.type == "IMAGE" {
                var imageView: UIImageView
                let xOrigin = self.imgScrollView.frame.size.width * CGFloat(i)
                imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: self.imgScrollView.frame.size.width, height: self.imgScrollView.frame.size.height))
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
//                let urlStr = dict.url
                let urlStr = "https://picsum.photos/400/250"
                imageView.downloadImage(urlString: urlStr)
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
        self.imgScrollView.contentSize = CGSize(width: self.imgScrollView.frame.size.width * CGFloat(sliderImagesArray.count), height: self.imgScrollView.frame.size.height)
        
        // Timer in viewdidload()
        if isAutoScroll {
            Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollSpeed), target: self, selector: #selector(moveToNextImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func moveToNextImage() {
        let imgsCount: CGFloat = CGFloat(sliderImagesArray.count)
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
        let dict = subViewArray[tag]
        if dict.campaignId != nil {
            CustomerGlu.getInstance.loadCampaignById(campaign_id: dict.campaignId)
        }
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
        view.backgroundColor = .red
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "BannerView", bundle: .module)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view!
    }
}
