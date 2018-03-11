//
//  AppHelper.swift
//  ArchitecturalDemo
//
//  Created by Rakesh Gujari on 03/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit
import SystemConfiguration

class AppHelper {
    
    private init() {}
    public static let `context` = AppHelper()
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        if ret == false {
            let alert = UIAlertController(title: "", message: "Device is offline. Please connect to internet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            (UIApplication.shared.delegate?.window??.rootViewController)?.present(alert, animated: true, completion: nil)
        }
        
        return ret
        
    }

    func showLoader() {
        self.removeLoader()
        let view = UIView(frame: CGRect(x: 0, y: Constants.ScreenDimensions.height/2-200, width: Constants.ScreenDimensions.width, height: 60))
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.frame = CGRect(x: view.frame.midX-25, y: view.frame.midY-25, width: 50, height: 50)
        view.addSubview(loader)
        loader.startAnimating()
        view.tag = 777
        (UIApplication.shared.delegate?.window??.rootViewController)?.view.addSubview(view)
    }
    
    func removeLoader() {
        let layout = (UIApplication.shared.delegate?.window??.rootViewController)?.view
        if let view = layout?.viewWithTag(777) {
            view.removeFromSuperview()
        }
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        (UIApplication.shared.delegate?.window??.rootViewController)?.present(alert, animated: true, completion: nil)
    }
    
    func getLabelHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size.height+10
    }
}
