//
//  PhotoViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 02.02.2022.
//

import UIKit

protocol PhotoViewer: UIViewController {
    var image: UIImage? { get set }
    var transitionController: ZoomTransitionController { get }
}

final class PhotoZoomViewController: UIViewController, PhotoViewer {
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    private var imageTopConstrain: NSLayoutConstraint?
    private var imageBottomConstrain: NSLayoutConstraint?
    private var imageLeadingConstrain: NSLayoutConstraint?
    private var imageTrailingConstrain: NSLayoutConstraint?
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    enum ScreenMode {
        case full, normal
    }
    
    private var currentMode: ScreenMode = .normal
    // screen taps counter
    private var numberOfTaps: Int = 0
    private var timer: Timer?
    
    public var transitionController = ZoomTransitionController()
    public var image: UIImage?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.navigationBar.barTintColor = .background.style(.accent)()
        view.backgroundColor = .black
        
        setupUI()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPerformed(gestureRecognizer:)))
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }
    
    // MARK: - UI setup
    private func setupUI() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        photoImageView.image = image
        scrollView.addSubview(photoImageView)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageTopConstrain = photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageTopConstrain?.isActive = true
        imageLeadingConstrain = photoImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        imageLeadingConstrain?.isActive = true
        imageBottomConstrain = photoImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        imageBottomConstrain?.isActive = true
        imageTrailingConstrain = photoImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        imageTrailingConstrain?.isActive = true
    }
    
    // MARK: - Interactions
    @objc
    private func tapPerformed(gestureRecognizer: UITapGestureRecognizer) {
        if(numberOfTaps == 0) {
            numberOfTaps += 1
            timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                self.didSingleTapWith(gestureRecognizer: gestureRecognizer)
                self.numberOfTaps = 0
            }
        } else {
            self.timer?.invalidate()
            self.didDoubleTapWith(gestureRecognizer: gestureRecognizer)
            self.numberOfTaps = 0
        }
    }
    
    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.scrollView.isScrollEnabled = false
            self.transitionController.isInteractive = true
            let _ = self.navigationController?.popViewController(animated: true)
        case .ended:
            if self.transitionController.isInteractive {
                self.scrollView.isScrollEnabled = true
                self.transitionController.isInteractive = false
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            if self.transitionController.isInteractive {
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }
    
    private func didSingleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        if(currentMode == .full) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            currentMode = .normal
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            currentMode = .full
        }

    }
    
    private func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        let pointInView = gestureRecognizer.location(in: self.photoImageView)
        var newZoomScale = self.scrollView.maximumZoomScale
        
        if self.scrollView.zoomScale >= newZoomScale || abs(self.scrollView.zoomScale - newZoomScale) <= 0.01 {
            newZoomScale = self.scrollView.minimumZoomScale
        }
        
        let width = self.scrollView.bounds.width / newZoomScale
        let height = self.scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        self.scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    
    private func updateZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / photoImageView.bounds.width
        let heightScale = size.height / photoImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale

        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = minScale * 4
    }

    private func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - photoImageView.frame.height) / 2)
        imageTopConstrain?.constant = yOffset
        imageBottomConstrain?.constant  = yOffset

        let xOffset = max(0, (size.width - photoImageView.frame.width) / 2)
        imageLeadingConstrain?.constant = xOffset
        imageTrailingConstrain?.constant = xOffset

        let contentHeight = yOffset * 2 + self.photoImageView.frame.height
        view.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: contentHeight)
    }

}

// MARK: - Scroll Delegate
extension PhotoZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(self.view.bounds.size)
    }
}

// MARK: - GestureRecognizerDelegate
extension PhotoZoomViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gestureRecognizer.velocity(in: self.view)
            let velocityCheck = velocity.y < 0
            if velocityCheck {
                return false
            }
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if otherGestureRecognizer == self.scrollView.panGestureRecognizer {
            if self.scrollView.contentOffset.y == 0 {
                return true
            }
        }
        return false
    }
}

// MARK: - ZoomAnimator Delegate
extension PhotoZoomViewController: ZoomAnimatorDelegate {
    
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return self.photoImageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        return self.scrollView.convert(self.photoImageView.frame, to: self.view)
    }
}
