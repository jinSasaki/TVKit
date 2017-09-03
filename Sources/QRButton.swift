//
//  QRButton.swift
//  TVKit
//
//  Created by Jin Sasaki on 2016/06/04.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//
//

import UIKit

public class QRButton: UIButton {
    @IBInspectable public var showsQR: Bool = false {
        didSet {
            if self.showsQR {
                self.showQR()
            } else {
                self.hiddenQR()
            }
        }
    }
    @IBInspectable public var code: String?
    @IBInspectable public var animated: Bool = true
    
    public var qrImageView: UIImageView?
    private func showQR() {
        guard let code = code else {
            return
        }
        let size = max(frame.width, frame.height)
        let qrImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        qrImageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        qrImageView.image = qrCodeImage(code: code)
        self.insertSubview(qrImageView, at: 0)
        
        if animated {
            qrImageView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                qrImageView.alpha = 1
            }
        }
        self.qrImageView = qrImageView
    }
    
    private func hiddenQR() {
        self.qrImageView?.removeFromSuperview()
        self.qrImageView = nil
    }
    
    private func qrCodeImage(code: String) -> UIImage? {
        if code.characters.count == 0 { return nil }
        
        let data = code.data(using: .utf8)
        if data?.count == 0 { return nil }
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter?.outputImage else { return nil }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        let image = UIImage(cgImage: cgImage, scale: 1, orientation: .up)
        
        // Resize without interpolating
        let rate: CGFloat = 6
        let width = image.size.width * rate
        let height = image.size.height * rate
        
        var resized: UIImage? = nil
        UIGraphicsBeginImageContext(CGSize(width: width, height: height));
        let graphicContext = UIGraphicsGetCurrentContext()
        
        graphicContext?.interpolationQuality = .none
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resized
    }
}

