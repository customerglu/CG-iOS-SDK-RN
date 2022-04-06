import UIKit

class FloatingButtonController: UIViewController {

    private(set) var imageview: UIImageView!
    var floatInfo: CGData?

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(btnInfo: CGData) {
        super.init(nibName: nil, bundle: nil)
        floatInfo = btnInfo
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(note:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    private let window = FloatingButtonWindow()

    override func loadView() {
        let view = UIView()
        
        let screenHeight = Int(UIScreen.main.bounds.height)
        let screenWidth = Int(UIScreen.main.bounds.width)
        
        let heightPer = Int((floatInfo?.mobile.container.height)!)!
        let widthPer = Int((floatInfo?.mobile.container.width)!)!
        
        let finalHeight = (screenHeight * heightPer)/100
        let finalWidth = (screenWidth * widthPer)/100
        
        let bottomSpace = (screenHeight * 5)/100
        let sideSpace = (screenWidth * 5)/100
        let topSpace = (screenHeight * 5)/100
        let midX = Int(UIScreen.main.bounds.midX)
        let midY = Int(UIScreen.main.bounds.midY)

        let imageview = UIImageView()

        if floatInfo?.mobile.container.position == "BOTTOM-LEFT" {
            imageview.frame = CGRect(x: sideSpace, y: screenHeight - (finalHeight + bottomSpace), width: finalWidth, height: finalHeight)
        } else if floatInfo?.mobile.container.position == "BOTTOM-RIGHT" {
            imageview.frame = CGRect(x: screenWidth - (finalWidth + sideSpace), y: screenHeight - (finalHeight + bottomSpace), width: finalWidth, height: finalHeight)
        } else if floatInfo?.mobile.container.position == "BOTTOM-CENTER" {
            imageview.frame = CGRect(x: midX - (finalWidth / 2), y: screenHeight - (finalHeight + bottomSpace), width: finalWidth, height: finalHeight)
        } else if floatInfo?.mobile.container.position == "TOP-LEFT" {
            imageview.frame = CGRect(x: sideSpace, y: topSpace, width: finalWidth, height: finalHeight)
        } else if floatInfo?.mobile.container.position == "TOP-RIGHT" {
            imageview.frame = CGRect(x: screenWidth - (finalWidth + sideSpace), y: topSpace, width: finalWidth, height: finalHeight)
        } else if floatInfo?.mobile.container.position == "TOP-CENTER" {
            imageview.frame = CGRect(x: midX - (finalWidth / 2), y: topSpace, width: finalWidth, height: finalHeight)
        } else if floatInfo?.mobile.container.position == "CENTER-LEFT" {
            imageview.frame = CGRect(x: sideSpace, y: midY - (finalHeight / 2), width: finalWidth, height: finalHeight)
        } else if floatInfo?.mobile.container.position == "CENTER-RIGHT" {
            imageview.frame = CGRect(x: screenWidth - (finalWidth + sideSpace), y: midY - (finalHeight / 2), width: finalWidth, height: finalHeight)
        } else {
            imageview.frame = CGRect(x: midX - (finalWidth / 2), y: midY - (finalHeight / 2), width: finalWidth, height: finalHeight)
        }
        
        imageview.downloadImage(urlString: (floatInfo?.mobile.content[0].url)!)
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        imageview.backgroundColor = UIColor.white
        imageview.layer.shadowColor = UIColor.black.cgColor
        imageview.layer.shadowRadius = 3
        imageview.layer.shadowOpacity = 0.8
        imageview.layer.shadowOffset = CGSize.zero
        imageview.autoresizingMask = []
        imageview.isUserInteractionEnabled = true
        
        if floatInfo?.mobile.container.borderRadius != nil {
            let radius = NumberFormatter().number(from: (floatInfo?.mobile.container.borderRadius)!)
            imageview.layer.cornerRadius = radius as! CGFloat
            imageview.clipsToBounds = true
        }
        
        view.addSubview(imageview)
        self.view = view
        self.imageview = imageview
        window.imageview = imageview
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        imageview.addGestureRecognizer(panGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imageview.addGestureRecognizer(tap)
    }
    public func hideFloatingButton(ishidden:Bool) {
        window.isHidden = ishidden
        window.imageview?.isHidden = ishidden
        self.imageview.isHidden = ishidden
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: imageview)
        imageview.center = CGPoint(x: imageview.center.x + translation.x, y: imageview.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: imageview)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        self.removeFromSuperview()
        if floatInfo?.mobile.content[0].openLayout == "FULL-DEFAULT" {
            CustomerGlu.getInstance.presentToCustomerWebViewController(nudge_url: (floatInfo?.mobile.content[0].url)!, page_type: Constants.FULL_SCREEN_NOTIFICATION, backgroundAlpha: 0.5)
        }
    }
    
    @objc func keyboardDidShow(note: NSNotification) {
        window.windowLevel = UIWindow.Level(rawValue: 0)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
    }

}

private class FloatingButtonWindow: UIWindow {

    var imageview: UIImageView?

    init() {
        super.init(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            self.windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!
        }
        backgroundColor = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let imageview = imageview else { return false }
        let imageviewPoint = convert(point, to: imageview)
        return imageview.point(inside: imageviewPoint, with: event)
    }
}
