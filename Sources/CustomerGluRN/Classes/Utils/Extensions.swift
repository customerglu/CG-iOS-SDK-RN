//
//  File.swift
//  
//
//  Created by kapil on 29/10/21.
//

import Foundation
import UIKit

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        CustomerGlu.getInstance.printlog(cglog: json, isException: false, methodName: "printJson", posttoserver: false)
    }
}

extension String {
    // Replace Space between Strings
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

extension UIViewController {
    static func topViewController() -> UIViewController? {
        
        if var presentedVC = UIApplication.shared.keyWindow?.rootViewController{
            // only for flotingbuttons
            if(presentedVC.isKind(of: FloatingButtonController.self)){
                let keyWindow = UIApplication.shared.windows[0]
                if var topController = keyWindow.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    return topController
                }
            }else{
                while let pVC = presentedVC.presentedViewController {
                    presentedVC = pVC
                }
                return presentedVC
            }
        }
        return UIViewController()
    }
}

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropViewShadow() {
        // Update Corners & Shadow
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
    }
}

extension UIImageView {
    
    func downloadImage(urlString: String, success: ((_ image: UIImage?) -> Void)? = nil, failure: ((String) -> Void)? = nil) {
        
        let imageCache = NSCache<NSString, UIImage>()
        
        DispatchQueue.main.async {[weak self] in
            self?.image = nil
        }
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {[weak self] in
                self?.image = image
            }
            success?(image)
        } else {
            guard let url = URL(string: urlString) else {
                CustomerGlu.getInstance.printlog(cglog: "failed to create url", isException: false, methodName: "Extensions-downloadImage", posttoserver: false)
                return
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {(data, _, error) in
                
                // response received, now switch back to main queue
                DispatchQueue.main.async {[weak self] in
                    if let error = error {
                        failure?(error.localizedDescription)
                    } else if let data = data {
                        var image = UIImage()
                        let imageExtensions = ["gif"]
                        let pathExtention = url.pathExtension
                        if imageExtensions.contains(pathExtention) {
                            image = UIImage.gif(data: data)!
                        } else {
                            image = UIImage(data: data) ?? UIImage()
                        }
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        self?.image = image
                        success?(image)
                    } else {
                        failure?("Image not available")
                    }
                }
            }
            task.resume()
        }
    }
}

extension UIApplication {
    /// The app's key window taking into consideration apps that support multiple scenes.
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

extension Date {
    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
            else{
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                if scanner.scanHexInt32(&hexNumber) {
                    let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
                    let g = CGFloat((hexNumber & 0xff00) >> 8) / 255.0
                    let b = CGFloat((hexNumber & 0xff) >> 0) / 255.0
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
                
            }
        }
        self.init(red:1, green: 1, blue: 1, alpha: 1.0)
        return
    }
    
    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b, a].map { String(format: "%02lX", Int($0 * 255)) }.reduce("#", +)
    }
}

// Below link will confirm to CellIdentifierProtocol for all cells in app
extension UITableViewCell: CellIdentifierProtocol {}

// MARK: - CellIdentifierProtocol
protocol CellIdentifierProtocol {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
    static var nib: String { get }
}

extension CellIdentifierProtocol where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static var nib: String {
        return String(describing: Self.self)
    }
}
