//
//  File.swift
//
//
//  Created by kapil on 1/2/22.
//

import UIKit
import Foundation
import WebKit

//EmbedView
public class CGEmbedView: UIView, WKNavigationDelegate, WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == WebViewsKey.callback {
            guard let bodyString = message.body as? String,
                  let bodyData = bodyString.data(using: .utf8) else { fatalError() }
            
            let bodyStruct = try? JSONDecoder().decode(CGEventModel.self, from: bodyData)
            
//            if bodyStruct?.eventName == WebViewsKey.close {
//                if notificationHandler || iscampignId {
//                    self.closePage(animated: true)
//                } else {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
            
//            if bodyStruct?.eventName == WebViewsKey.open_deeplink {
//                let deeplink = try? JSONDecoder().decode(CGDeepLinkModel.self, from: bodyData)
//                if  let deep_link = deeplink?.data?.deepLink {
//                    print("link", deep_link)
//                    postdata = OtherUtils.shared.convertToDictionary(text: (message.body as? String)!) ?? [String:Any]()
//                    self.canpost = true
//                    if self.auto_close_webview == true {
//                        // Posted a notification in viewDidDisappear method
//                        if notificationHandler || iscampignId {
//                            self.closePage(animated: true)
//                        } else {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }else{
//                        // Post notification
//                        self.canpost = false
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name("CUSTOMERGLU_DEEPLINK_EVENT").rawValue), object: nil, userInfo: self.postdata)
//                        self.postdata = [String:Any]()
//                    }
//                }
//            }
            
//            if bodyStruct?.eventName == WebViewsKey.share {
//                let share = try? JSONDecoder().decode(CGEventShareModel.self, from: bodyData)
//                let text = share?.data?.text
//                let channelName = share?.data?.channelName
//                if let imageurl = share?.data?.image {
//                    if imageurl == "" {
//                        if channelName == "WHATSAPP" {
//                            sendToWhatsapp(shareText: text!)
//                        } else {
//                            sendToOtherApps(shareText: text!)
//                        }
//                    } else {
//                        if channelName == "WHATSAPP" {
//                            shareImageToWhatsapp(imageString: imageurl, shareText: text ?? "")
//                        } else {
//                            sendImagesToOtherApp(imageString: imageurl, shareText: text ?? "")
//                        }
//                    }
//
////                    if self.auto_close_webview == true {
////                        // Posted a notification in viewDidDisappear method
////                        if openWallet {
////                            delegate?.closeClicked(true)
////                        } else if notificationHandler || iscampignId {
////                            self.closePage(animated: true)
////                        } else {
////                            self.navigationController?.popViewController(animated: true)
////                        }
////                    }
//
//                }
//            }
            
            if bodyStruct?.eventName == WebViewsKey.analytics {
                if (true == CustomerGlu.analyticsEvent) {
                    let dict = OtherUtils.shared.convertToDictionary(text: (message.body as? String)!)
                    if(dict != nil && dict!.count>0 && dict?["data"] != nil){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name("CUSTOMERGLU_ANALYTICS_EVENT").rawValue), object: nil, userInfo: dict?["data"] as? [String: Any])
                    }
                }
            }
            
            if bodyStruct?.eventName == WebViewsKey.updateheight {
                if (true == CustomerGlu.analyticsEvent) {
                    let dict = OtherUtils.shared.convertToDictionary(text: (message.body as? String)!)
                    if(dict != nil && dict!.count>0 && dict?["data"] != nil){
                        
                        let dictheight = dict?["data"] as! [String: Any]
                        if(dictheight != nil && dictheight.count > 0 && dictheight["height"] != nil){
                            finalHeight = (dictheight["height"])! as! Double
                            embedviewHeightchanged(height: finalHeight)
                        }

//                        setEmbedView(height: finalHeight, isAutoScrollEnabled: false, autoScrollSpeed: 1)
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name("CUSTOMERGLU_ANALYTICS_EVENT").rawValue), object: nil, userInfo: dict?["data"] as? [String: Any])
                    }
                }
            }
        }
    }
    
    
    var view = UIView()
    var arrContent = [CGContent]()
    var condition : CGCondition?
    private var code = true
    var finalHeight = 0.0
    private var loadedapicalled = false
    
    var webView = WKWebView()
    let contentController = WKUserContentController()
    let config = WKWebViewConfiguration()
    var documentInteractionController: UIDocumentInteractionController!
    
    @IBInspectable var embedId: String? {
        didSet {
            backgroundColor = UIColor.clear
            CustomerGlu.getInstance.postEmbedsCount()
            reloadEmbedView()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.entryPointLoaded),
                name: Notification.Name("EntryPointLoaded"),
                object: nil)
        }
    }

    @objc private func entryPointLoaded(notification: NSNotification) {
            self.reloadEmbedView()
    }
    
    var commonEmbedId: String {
        get {
            return self.embedId ?? ""
        }
        set(newWeight) {
            embedId = newWeight
        }
    }

    public init(frame: CGRect, embedId: String) {
        //CODE
        super.init(frame: frame)
        code = true
        self.xibSetup()
        self.commonEmbedId = embedId
    }
    
    required init?(coder aDecoder: NSCoder) {
        // XIB
        super.init(coder: aDecoder)
        code = false
        self.xibSetup()
    }
    
    public override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: CGFloat(finalHeight))
    }
        
    // MARK: - Nib handlers
    private func xibSetup() {
        self.autoresizesSubviews = true
        view = UIView()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizesSubviews = true
        
        contentController.add(self, name: WebViewsKey.callback) //name is the key you want the app to listen to.
        config.userContentController = contentController
        
        addSubview(view)
    }
    
    public func reloadEmbedView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
//        DispatchQueue.main.async { [self] in
            
            
            if self.view != nil {
                self.view.subviews.forEach({ $0.removeFromSuperview() })
            }
            
        let embedViews = CustomerGlu.entryPointdata.filter {
            $0.mobile.container.type == "EMBEDDED" && $0.mobile.container.bannerId == self.embedId
            }
            
            if embedViews.count != 0 {
                let mobile = embedViews[0].mobile!
                arrContent = [CGContent]()
                condition = mobile.conditions
                
                if mobile.content.count != 0 {
                    for content in mobile.content {
                        arrContent.append(content)
                    }
                    
                    
                    self.setEmbedView(height:mobile.content[0].absoluteHeight ?? 0.0, isAutoScrollEnabled: mobile.conditions.autoScroll, autoScrollSpeed: mobile.conditions.autoScrollSpeed)
//                    callLoadEmbedAnalytics()
                } else {
                    embedviewHeightchanged(height: 0.0)
                }
            } else {
                embedviewHeightchanged(height: 0.0)
            }
        }
    }
    
    private func embedviewHeightchanged(height : Double) {
        finalHeight = height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            
            self.constraints.filter{$0.firstAttribute == .height}.forEach({ $0.constant = CGFloat(finalHeight) })
            self.frame.size.height = CGFloat(finalHeight)
            self.view.frame.size.height = CGFloat(finalHeight)
            self.webView.frame.size.height = CGFloat(finalHeight)

            let postInfo: [String: Any] = [self.embedId ?? "" : finalHeight]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name("CGEMBED_FINAL_HEIGHT").rawValue), object: nil, userInfo: postInfo)
            
            invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
            
        }
    }
   
    private func setEmbedView(height: Double, isAutoScrollEnabled: Bool, autoScrollSpeed: Int){

        let screenWidth = self.frame.size.width
        let screenHeight = UIScreen.main.bounds.height
        finalHeight = height
        
        let postInfo: [String: Any] = [self.embedId ?? "" : finalHeight]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name("CGEMBED_FINAL_HEIGHT").rawValue), object: nil, userInfo: postInfo)
  
        self.constraints.filter{$0.firstAttribute == .height}.forEach({ $0.constant = CGFloat(finalHeight) })
        self.frame.size.height = CGFloat(finalHeight)
        if self.view != nil {
            self.view.frame.size.height = CGFloat(finalHeight)
        }
        
            let dict = arrContent[0]
            let xOrigin = screenWidth * CGFloat(0)
            webView = WKWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(finalHeight)), configuration: config)
            webView.isUserInteractionEnabled = true
            webView.tag = 0
            let urlStr = dict.url
            webView.load(URLRequest(url: URL(string: "https://bmp7u0.csb.app/")!))
//                webView.load(URLRequest(url: CustomerGlu.getInstance.validateURL(url: URL(string: urlStr!)!)))
            self.view.addSubview(webView)

        invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
//    private func getconfiguredheight()->CGFloat {
//        var finalheight = (self.view.frame.height) * (70/100)
//
//        if(nudgeConfiguration != nil){
//            if(nudgeConfiguration!.relativeHeight > 0){
//                finalheight = (self.view.frame.height) * (nudgeConfiguration!.relativeHeight/100)
//            }else if(nudgeConfiguration!.absoluteHeight > 0){
//                finalheight = nudgeConfiguration!.absoluteHeight
//            }
//        }
//
//        return finalheight
//    }


//    private func eventPublishNudge(pageName: String, nudgeId: String, actionType: String, actionTarget: String, pageType: String, campaignId: String) {
//        var eventInfo = [String: AnyHashable]()
//        eventInfo[APIParameterKey.nudgeType] = "EMBED"
//
//        eventInfo[APIParameterKey.pageName] = pageName
//        eventInfo[APIParameterKey.nudgeId] = nudgeId
//        eventInfo[APIParameterKey.actionTarget] = actionTarget
//        eventInfo[APIParameterKey.actionType] = actionType
//        eventInfo[APIParameterKey.pageType] = pageType
//
//        eventInfo[APIParameterKey.campaignId] = "CAMPAIGNID_NOTPRESENT"
//        if actionTarget == "CAMPAIGN" {
//            if campaignId.count > 0 {
//                if !(campaignId.contains("http://") || campaignId.contains("https://")) {
//                    eventInfo[APIParameterKey.campaignId] = campaignId
//                }
//            }
//        }
//
//        eventInfo[APIParameterKey.optionalPayload] = [String: String]() as [String: String]
//
//        ApplicationManager.publishNudge(eventNudge: eventInfo) { success, _ in
//            if success {
//
//            } else {
//                CustomerGlu.getInstance.printlog(cglog: "Fail to call eventPublishNudge", isException: false, methodName: "EmbedView-eventPublishNudge", posttoserver: true)
//            }
//        }
//    }
    
//    private func callLoadEmbedAnalytics(){
//
//        if (false == loadedapicalled){
//            let embedViews = CustomerGlu.entryPointdata.filter {
//                $0.mobile.container.type == "EMBED" && $0.mobile.container.embedId == self.embedId ?? ""
//            }
//
//            if embedViews.count != 0 {
//                let mobile = embedViews[0].mobile!
//                arrContent = [CGContent]()
//                condition = mobile.conditions
//
//                if mobile.content.count != 0 {
//                    for content in mobile.content {
//                        arrContent.append(content)
//                        var actionTarget = ""
//                        if content.campaignId.count == 0 {
//                            actionTarget = "WALLET"
//                        } else if content.campaignId.contains("http://") || content.campaignId.contains("https://"){
//                            actionTarget = "CUSTOM_URL"
//                        } else {
//                            actionTarget = "CAMPAIGN"
//                        }
//
//                        eventPublishNudge(pageName: CustomerGlu.getInstance.activescreenname, nudgeId: content._id, actionType: "LOADED", actionTarget: actionTarget, pageType: content.openLayout, campaignId: content.campaignId)
//                    }
//                    loadedapicalled = true
//                }
//            }
//        }
//    }
}
