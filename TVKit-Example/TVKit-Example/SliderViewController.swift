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
        slider.leftLabel.hidden = true
    }
    
    @IBAction func tapResetButton(sender: AnyObject) {
        slider.setValue(0, animated: true)
    }
    
    @IBAction func tapStartButton(sender: AnyObject) {
        slider.indicator.startAnimating()
    }
    
    @IBAction func tapStopButton(sender: AnyObject) {
        slider.indicator.stopAnimating()
    }
    
    private func formatForTime(time: Double) -> String {
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
    
    func slider(slider: Slider, textWithValue value: Double) -> String {
        return formatForTime(value)
    }
    
    func slider(slider: Slider, didChangeValue value: Double) {
        slider.rightLabel.text = formatForTime(value - slider.max)
    }
}
