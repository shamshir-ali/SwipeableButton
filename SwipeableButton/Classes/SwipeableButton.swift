//
//  SwipeableButton.swift
//  SwipeableButton
//
//  Created by Shamshir Ali on 08/03/2021.
//

import UIKit
protocol SwipeableButtonDelegate: class {
    func swipableButtonSelected(_ isSelected: Bool)
}
class SwipeableButton: UIView {

    var imageContainer: UIView = UIView()
    var lblActive: UILabel = UILabel()
    var lblInactive: UILabel = UILabel()
    var imageview: UIImageView = UIImageView()
    var mainView: UIView = UIView()
    weak var swipeableDelegate: SwipeableButtonDelegate?
    private let mainTag: Int = 999
    //    MARK: - Head colors
    @IBInspectable var headActiveColor: UIColor = UIColor.gray
    @IBInspectable var headInctiveColor: UIColor = UIColor.orange
    //    MARK: - Track colors
    @IBInspectable var trackActiveColor: UIColor = UIColor.orange
    @IBInspectable var trackInctiveColor: UIColor = UIColor.gray
    //    MARK: - Label colors
    @IBInspectable var labelActiveColor: UIColor = UIColor.white
    @IBInspectable var labelInctiveColor: UIColor = UIColor.white
    //    MARK: - Header Image
    @IBInspectable var inactiveImage: UIImage = #imageLiteral(resourceName: "outline_lock")
    @IBInspectable var activeImage: UIImage = #imageLiteral(resourceName: "outline_unlock")
    //    MARK: - Text
    @IBInspectable var activeText: String = ""
    @IBInspectable var inactiveText: String = ""
    @objc func pangesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .began:
                lblInactive.isHidden = true
                lblActive.isHidden = true
            case .changed:
                panValueDidChanged(sender)
            case .ended:
                panGestureDidEnd(sender)
            default:
                return
        }
        
    }
    func panValueDidChanged(_ sender: UIPanGestureRecognizer) {
        guard let recognizerView = sender.view else {
            return
        }
        let translation = sender.translation(in: mainView)
        guard recognizerView.frame.origin.x >= .zero else {
            recognizerView.frame.origin.x = .zero
            sender.setTranslation(.zero, in: mainView)
            return
        }
        guard recognizerView.frame.origin.x <= mainView.frame.width - recognizerView.frame.width else {
            recognizerView.frame.origin.x = (mainView.frame.width - recognizerView.frame.width)
            sender.setTranslation(.zero, in: mainView)
            return
        }
        if recognizerView.center.x > mainView.frame.width * 0.5 {
            mainView.backgroundColor = trackActiveColor
            self.imageview.image = activeImage
            recognizerView.backgroundColor = headActiveColor
        } else {
            mainView.backgroundColor = trackInctiveColor
            self.imageview.image = inactiveImage
            recognizerView.backgroundColor = headInctiveColor
        }

        recognizerView.center.x += translation.x
        sender.setTranslation(.zero, in: mainView)
    }
    func panGestureDidEnd(_ sender: UIPanGestureRecognizer) {
        guard let recognizerView = sender.view else {
            return
        }
        _ = sender.translation(in: mainView)
        guard recognizerView.center.x < mainView.frame.width * 0.5 else {
            let delay = recognizerView.frame.origin.x / mainView.frame.width
            UIView.animate(withDuration: TimeInterval(delay), animations: {
                recognizerView.center.x = (self.mainView.frame.width - (recognizerView.frame.width * 0.5))
                sender.setTranslation(.zero, in: self.mainView)
                self.imageview.image = self.activeImage
                recognizerView.backgroundColor = self.headActiveColor
            }, completion: { (completed) in
                if completed {
                    self.lblActive.isHidden = false
                    self.swipeableDelegate?.swipableButtonSelected(true)
                }
            })

            mainView.backgroundColor = trackActiveColor
            return
        }
        guard recognizerView.center.x > mainView.frame.width * 0.5 else {
            let delay = recognizerView.frame.origin.x / (mainView.frame.width * 0.5)

            UIView.animate(withDuration: TimeInterval(delay), animations: {
                recognizerView.center.x = (recognizerView.frame.width * 0.5)
                sender.setTranslation(.zero, in: self.mainView)
                self.imageview.image = self.inactiveImage
                recognizerView.backgroundColor = self.headInctiveColor
            }, completion: { (completed) in
                if completed {
                    self.lblInactive.isHidden = false
                    self.swipeableDelegate?.swipableButtonSelected(false)

                }
            })
            
            mainView.backgroundColor = trackInctiveColor
            return
        }
        
    }
    func setUI() {
    }
    override func layoutSubviews() {
        setupView()
    }
    func setupView() {
        if let parentView = self.viewWithTag(mainTag) {
            parentView.removeFromSuperview()
        }
        let mainViewHeight = setMainViewConstraints()
        setAcceptedLabelConstraints(mainViewHeight)
        setAcceptLabelConstraints(mainViewHeight)
        let imgContainerHeight = setImageContainerConstraints(mainViewHeight)
        setImageViewConstraints(imgContainerHeight)
        setUI()
    }
    func setMainViewConstraints() -> NSLayoutConstraint {
        mainView.tag = mainTag
        self.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        let mainViewHeight = mainView.heightAnchor.constraint(equalToConstant: self.frame.height * 0.5 )
        mainViewHeight.isActive = true
        mainView.layer.cornerRadius = mainViewHeight.constant * 0.5
        mainView.backgroundColor = trackInctiveColor
        return mainViewHeight
    }
    func setAcceptedLabelConstraints(_ mainViewHeight: NSLayoutConstraint) {
        lblActive.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(lblActive)
        lblActive.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        lblActive.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10).isActive = true
        lblActive.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -mainViewHeight.constant * 1.55).isActive = true
        lblActive.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        lblActive.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        lblInactive.autoresizingMask = .flexibleHeight
        lblActive.text = activeText
        lblActive.numberOfLines = .zero
        lblActive.textAlignment = .center
        lblActive.textColor = labelActiveColor
        lblActive.adjustsFontSizeToFitWidth = true

    }
    
    func setAcceptLabelConstraints(_ mainViewHeight: NSLayoutConstraint) {
        lblInactive.translatesAutoresizingMaskIntoConstraints = false
        lblActive.isHidden = true
        mainView.addSubview(lblInactive)
        lblInactive.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        lblInactive.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10).isActive = true
        lblInactive.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: mainViewHeight.constant * 1.55).isActive = true
        lblInactive.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        lblInactive.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        lblInactive.numberOfLines = .zero
        lblInactive.text = inactiveText
        lblInactive.textAlignment = .center
        lblInactive.textColor = labelInctiveColor
        lblInactive.adjustsFontSizeToFitWidth = true
    }
    func setImageContainerConstraints(_ mainViewHeight: NSLayoutConstraint) -> NSLayoutConstraint {
        mainView.addSubview(imageContainer)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        imageContainer.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        imageContainer.widthAnchor.constraint(equalToConstant: mainViewHeight.constant * 1.5).isActive = true
        let imgContainerHeight = imageContainer.heightAnchor.constraint(equalToConstant: mainViewHeight.constant * 1.5)
        imgContainerHeight.isActive = true
        imageContainer.layer.cornerRadius = imgContainerHeight.constant * 0.5
        imageContainer.backgroundColor = headInctiveColor
        return imgContainerHeight
    }
    func setImageViewConstraints(_ imgContainerHeight: NSLayoutConstraint){
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageview)
        imageview.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: imgContainerHeight.constant * 0.75).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: imgContainerHeight.constant * 0.75).isActive = true
        imageview.image = inactiveImage
        imageContainer.isUserInteractionEnabled = true
        imageContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pangesture(_:))))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
