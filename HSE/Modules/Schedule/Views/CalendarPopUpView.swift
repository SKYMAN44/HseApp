//
//  CalendarPopUpView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 14.01.2022.
//

import UIKit

final class CalendarPopUpView: UIView, UIScrollViewDelegate {
    var backgroundView: UIView!
    var popUpView: UIView!
    var dismissButton: UIButton!
    
    var totalSlidingDistance = CGFloat()
    
    var panGesture : UIPanGestureRecognizer!
    
    deinit {
        print("deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: ScreenSize.Height, width: ScreenSize.Width, height: ScreenSize.Height))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(animatePopUpView(sender:)))
        
        // Background
        backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = .clear
        backgroundView.isUserInteractionEnabled = true
        addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleDismiss(sender:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Pop Up View
        popUpView = UIView(frame: CGRect(x: 0, y: ScreenSize.Height * 0.5, width: ScreenSize.Width, height: ScreenSize.Height * 0.5))
        popUpView.backgroundColor = .background.style(.firstLevel)()
        self.popUpView.isUserInteractionEnabled = true
        addSubview(popUpView)
        
        popUpView.addGestureRecognizer(panGesture)
        
        let rounded = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: CGSize.init(width: ScreenSize.Width, height: ScreenSize.Height * 0.5)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 12.0, height: 12.0))
        
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        popUpView.layer.mask = shape
        
        
        let calendar = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        calendar.tintColor = .primary.style(.primary)()
        
        popUpView.addSubview(calendar)
        
        calendar.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 16).isActive = true
        calendar.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 16).isActive = true
        calendar.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: 16).isActive = true
        
        // Dismiss Button
        dismissButton = UIButton(frame: CGRect(x: ScreenSize.Width - 45, y: 15, width: 30, height: 30))
        dismissButton.setTitle("", for: .normal)
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .black
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        popUpView.addSubview(dismissButton)
        
        
    }
    
    let blurView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.Width, height: ScreenSize.Height))
        let blurEffect = UIBlurEffect.init(style: .systemMaterialDark)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.alpha = 0.4
        view.addSubview(visualEffectView)
        view.alpha = 0
        return view
    } ()
    
    // MARK: - Display Animations
    
    // Add CommentPopUpView in the front of the current window
    
    @objc func show(){
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        sceneDelegate.window?.addSubview(blurView)
        sceneDelegate.window?.addSubview(self)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.frame.origin.y = 0
            self.blurView.alpha = 1
        }) { _ in
        }
    }
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.blurView.alpha = 0
            self.frame.origin.y = ScreenSize.Height
        }) { _ in
            self.removeFromSuperview()
            self.blurView.removeFromSuperview()
        }
    }
    
    @objc func handleDismiss(sender: UITapGestureRecognizer){
        let point = sender.location(in: self)
        if self.backgroundView.layer.contains(point) {
            dismiss()
        }
    }
    
    @objc func animatePopUpView(sender: UIPanGestureRecognizer){
        let transition = sender.translation(in: popUpView)
        
        // Rules: PopupView cannot go over the min Y, only dismiss when the gesture velocity exceeds 300
        switch sender.state {
        case .began, .changed:
            
            let slidingDistanceNormalized = transition.y / 300
            print("____-__-_--__-______\(slidingDistanceNormalized)")
            //Only allow swipe down or up to the minY of PopupView
            if(totalSlidingDistance <= 0 && transition.y < 0)  {return}
            if(self.frame.origin.y + transition.y >= 0) {
                self.frame.origin.y += transition.y
                self.blurView.alpha -= slidingDistanceNormalized
                sender.setTranslation(.zero, in: popUpView)
                totalSlidingDistance += transition.y
            }

        case .ended:
            //Pan gesture ended
            if(sender.velocity(in: popUpView).y > 300) {
                dismiss()
            } else if(totalSlidingDistance >= 0) {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut]) {
                    self.frame.origin.y -= self.totalSlidingDistance
                    self.blurView.alpha = 1
                    self.layoutIfNeeded()
                }
            }
            totalSlidingDistance = 0
        default:
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut]) {
                self.frame.origin.y -= self.totalSlidingDistance
                self.blurView.alpha = 1
                self.layoutIfNeeded()
            }
            totalSlidingDistance = 0
        }
    }

}

