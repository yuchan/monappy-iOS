//
//  ViewController.swift
//  monappy
//
//  Created by Yusuke Ohashi on 2017/07/13.
//  Copyright © 2017 Yusuke Ohashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let url = URL(string: "https://api.monappy.jp/v1/users/get_address?nickname=junkpiano") {
            let client = Client(with: url)
            client.send({ (json, error) in
                DispatchQueue.main.async {
                    [weak self] in
                    if let wSelf = self {
                        if let dict = json as? [String: Any] {
                            if let address = dict["address"] as? String {
                                wSelf.addressLabel.text = address
                                var qrcodeImage: CIImage!
                                let data = ("monacoin:" + address).data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                                
                                let filter = CIFilter(name: "CIQRCodeGenerator")
                                
                                filter?.setValue(data, forKey: "inputMessage")
                                filter?.setValue("Q", forKey: "inputCorrectionLevel")
                                
                                qrcodeImage = filter?.outputImage
                                
                                let scaleX = wSelf.imgQRCode.frame.size.width / qrcodeImage.extent.size.width
                                let scaleY = wSelf.imgQRCode.frame.size.height / qrcodeImage.extent.size.height
                                
                                let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
                                
                                wSelf.imgQRCode.image = UIImage(ciImage: transformedImage)
                            }
                        }
                    }
                }
            })
        }
        
        title = "Wallet"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

