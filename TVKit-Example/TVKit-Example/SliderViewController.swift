//
//  SliderViewController.swift
//  TVKit-Example
//
//  Created by Jin Sasaki on 2016/06/04.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit
import TVKit

class SliderViewController: UIViewController {
    
    @IBOutlet weak var slider: Slider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.delegate = self
        slider.max = 60 * 4
        slider.leftLabel.isHidden = true
    }
    
    @IBAction func tapResetButton(_ sender: AnyObject) {
        slider.set(value: 0, animated: true)
    }
    
    @IBAction func tapStartButton(_ sender: AnyObject) {
        slider.indicator.startAnimating()
    }
    
    @IBAction func tapStopButton(_ sender: AnyObject) {
        slider.indicator.stopAnimating()
    }
    
    private func format(forTime time: Double) -> String {
        let sign = time < 0 ? -1.0 : 1.0
        let minutes = Int(time * sign) / 60
        let seconds = Int(time * sign) % 60
        return (sign < 0 ? "-" : "") + "\(minutes):" + String(format: "%02d", seconds)
    }
}

extension SliderViewController: SliderDelegate {
    func sliderDidTap(slider: Slider) {
        print("tapped")
    }
    
    func slider(_ slider: Slider, textWithValue value: Double) -> String {
        return format(forTime: value)
    }
    
    func slider(_ slider: Slider, didChangeValue value: Double) {
        slider.rightLabel.text = format(forTime: value - slider.max)
    }
}
