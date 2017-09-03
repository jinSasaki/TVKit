//
//  Slider.swift
//  TVKit
//
//  Created by Jin Sasaki on 2016/05/10.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit

public protocol SliderDelegate: class {
    func slider(slider: Slider, textWithValue value: Double) -> String

    func sliderDidTap(slider: Slider)
    func slider(slider: Slider, didChangeValue value: Double)
    func slider(slider: Slider, didUpdateFocusInContext context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
}

public extension SliderDelegate {
    func slider(slider: Slider, textWithValue value: Double) -> String { return "\(Int(value))" }

    func sliderDidTap(slider: Slider) {}
    func slider(slider: Slider, didChangeValue value: Double) {}
    func slider(slider: Slider, didUpdateFocusInContext context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {}
}

@IBDesignable
public class Slider: UIView {

    // MARK: - Public
    
    
    /**
      Contains the receiver’s current value.
     
     Setting this property causes the receiver to redraw itself using the new value. To render an animated transition from the current value to the new value, you should use the setValue:animated: method instead.
     
     If you try to set a value that is below the minimum or above the maximum value, the minimum or maximum value is set instead. The default value of this property is 0.0.
    */
    @IBInspectable public var value: Double = 0 {
        didSet {
            updateViews()
            delegate?.slider(self, didChangeValue: value)
        }
    }
    @IBInspectable public var max: Double = 100 {
        didSet {
            updateViews()
        }
    }
    @IBInspectable public var min: Double = 0 {
        didSet {
            updateViews()
        }
    }

    @IBOutlet public private(set) weak var barView: UIView!
    @IBOutlet public private(set) weak var seekerView: UIView!
    @IBOutlet public private(set) weak var seekerLabel: UILabel!
    @IBOutlet public private(set) weak var leftLabel: UILabel!
    @IBOutlet public private(set) weak var rightLabel: UILabel!
    @IBOutlet public private(set) weak var indicator: UIActivityIndicatorView!
    @IBOutlet public private(set) weak var rightImageView: UIImageView!
    @IBOutlet public private(set) weak var leftImageView: UIImageView!

    public weak var delegate: SliderDelegate?

    public var animationSpeed: Double = 1.0
    public var decelerationRate: CGFloat = 0.92
    public var decelerationMaxVelocity: CGFloat = 1000

    public func setValue(value: Double, animated: Bool) {
        stopDeceleratingTimer()
        if distance == 0 {
            self.value = value
            return
        }
        let duration = fabs(self.value - value) / distance * animationSpeed
        self.value = value
        if animated {
            UIView.animateWithDuration(duration, animations: {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            })
        } else {
            self.value = value
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        updateViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        updateViews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        updateViews()
    }

    public override func canBecomeFocused() -> Bool {
        return true
    }

    public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)

        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.seekerView.transform = CGAffineTransformMakeTranslation(0, -12)
                self.seekerLabelBackgroundInnerView.backgroundColor = UIColor.whiteColor()
                self.seekerLabel.textColor = UIColor.blackColor()
                self.seekerLabelBackgroundView.layer.shadowOpacity = 0.5
                self.seekLineView.layer.shadowOpacity = 0.5
                }, completion: nil)

        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.seekerView.transform = CGAffineTransformIdentity
                self.seekerLabelBackgroundInnerView.backgroundColor = UIColor.lightGrayColor()
                self.seekerLabel.textColor = UIColor.whiteColor()
                self.seekerLabelBackgroundView.layer.shadowOpacity = 0
                self.seekLineView.layer.shadowOpacity = 0
                }, completion: nil)
        }
    }

    // MARK: - Private
    @IBOutlet private(set) weak var seekerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var seekLineView: UIView!
    @IBOutlet private(set) weak var seekerLabelBackgroundView: UIView!
    @IBOutlet private(set) weak var seekerLabelBackgroundInnerView: UIView!

    private var seekerViewLeadingConstraintConstant: CGFloat = 0
    private weak var deceleratingTimer: NSTimer?
    private var deceleratingVelocity: CGFloat = 0
    private var distance: Double {
        return 100 //fabs(max - min)
    }

    private func commonInit() {
        print("★")
        let b = NSBundle(forClass: self.dynamicType)
        print(b)
        let apath = b.pathForResource("TVKit", ofType: "bundle")
        print(apath)
        guard let path = apath else {
            print("🍺")
            return
        }
        let bundle = NSBundle(path: NSBundle(forClass: self.dynamicType).pathForResource("TVKit", ofType: "bundle")!)
        let nib = UINib(nibName: "Slider", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))

        barView.layer.cornerRadius = 6

        seekerLabelBackgroundInnerView.layer.cornerRadius = 4
        seekerLabelBackgroundInnerView.layer.masksToBounds = true
        seekerLabelBackgroundView.layer.cornerRadius = 4
        seekerLabelBackgroundView.layer.shadowRadius = 3
        seekerLabelBackgroundView.layer.shadowOpacity = 0
        seekerLabelBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 1)

        seekLineView.layer.shadowRadius = 3
        seekLineView.layer.shadowOpacity = 0
        seekLineView.layer.shadowOffset = CGSize(width: 1, height: 1)

        leftLabel.text = "\(min)"
        rightLabel.text = "\(max)"

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }

    dynamic private func handlePanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(self)
        let velocity = panGestureRecognizer.velocityInView(self)
        switch panGestureRecognizer.state {
        case .Began:
            stopDeceleratingTimer()
            seekerViewLeadingConstraintConstant = seekerViewLeadingConstraint.constant
        case .Changed:
            let leading = seekerViewLeadingConstraintConstant + translation.x / 5
            setValueWithPercentage(Double(leading / barView.frame.width))
        case .Ended, .Cancelled:
            seekerViewLeadingConstraintConstant = seekerViewLeadingConstraint.constant

            let direction: CGFloat = velocity.x > 0 ? 1 : -1
            deceleratingVelocity = fabs(velocity.x) > decelerationMaxVelocity ? decelerationMaxVelocity * direction : velocity.x
            deceleratingTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(handleDeceleratingTimer(_:)), userInfo: nil, repeats: true)
        default:
            break
        }
    }

    dynamic private func handleTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        stopDeceleratingTimer()
        delegate?.sliderDidTap(self)
    }

    dynamic private func handleDeceleratingTimer(timer: NSTimer) {
        let leading = seekerViewLeadingConstraintConstant + deceleratingVelocity * 0.01
        setValueWithPercentage(Double(leading / barView.frame.width))
        seekerViewLeadingConstraintConstant = seekerViewLeadingConstraint.constant

        deceleratingVelocity *= decelerationRate
        if !focused || fabs(deceleratingVelocity) < 1 {
            stopDeceleratingTimer()
        }
    }

    private func stopDeceleratingTimer() {
        deceleratingTimer?.invalidate()
        deceleratingTimer = nil
        deceleratingVelocity = 0
    }

    private func setValueWithPercentage(percentage: Double) {
        self.value = distance * Double(percentage > 1 ? 1 : (percentage < 0 ? 0 : percentage)) + min
    }

    private func updateViews() {
        if distance == 0 { return }
        seekerViewLeadingConstraint.constant = barView.frame.width * CGFloat((value - min) / distance)
        seekerLabel.text = delegate?.slider(self, textWithValue: value) ?? "\(Int(value))"
    }
}


extension Slider: UIGestureRecognizerDelegate {
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(self)
            if fabs(translation.x) > fabs(translation.y) {
                return focused
            }
        }
        return false
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
