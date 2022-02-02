//
//  PhotoViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 02.02.2022.
//

import UIKit

class PhotoZoomViewController: UIViewController {
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    public var image: UIImage?
    
    private var imageTopConstrain: NSLayoutConstraint?
    private var imageBottomConstrain: NSLayoutConstraint?
    private var imageLeadingConstrain: NSLayoutConstraint?
    private var imageTrailingConstrain: NSLayoutConstraint?
    
    var transitionController = ZoomTransitionController()
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapWith(gestureRecognizer:)))
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(self.doubleTapGestureRecognizer)
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
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
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
    
    @objc func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
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
    
    
    fileprivate func updateZoomScaleForSize(_ size: CGSize) {

        let widthScale = size.width / photoImageView.bounds.width
        let heightScale = size.height / photoImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale

        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = minScale * 4
    }

    fileprivate func updateConstraintsForSize(_ size: CGSize) {
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

extension PhotoZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(self.view.bounds.size)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.delegate?.photoZoomViewController(self, scrollViewDidScroll: scrollView)
//    }
}

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
