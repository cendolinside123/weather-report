//
//  LoadingView.swift
//  Loading
//
//  Created by Jan Sebastian on 21/03/22.
//

import UIKit

public class LoadingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView()
        spiner.color = .gray
        return spiner
    }()
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addLayout()
        addConstraints()
        setBorderWidth(set: 0)
        setBorderColor(set: UIColor.white.cgColor)
    }

    private func addLayout() {
        self.addSubview(loadingView)
        loadingView.addSubview(loadingSpinner)
    }
    
    private func addConstraints() {
        let views: [String: Any] = ["loadingSpinner": loadingSpinner, "loadingView": loadingView]
        let metrix: [String: Any] = [:]
        var constraints: [NSLayoutConstraint] = []
        
        // MARK: loadingView constraints
        let hLoadingView = "H:|-0-[loadingView]-0-|"
        let vLoadingView = "V:|-0-[loadingView]-0-|"
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vLoadingView, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hLoadingView, options: .alignAllTop, metrics: metrix, views: views)
        // MARK: loadingSpinner constraints
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: loadingSpinner, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: loadingSpinner, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
extension LoadingView {
    public func startAnimate() {
        loadingSpinner.startAnimating()
    }
    
    public func stopAnimate() {
        loadingSpinner.stopAnimating()
    }
    
    public func setbackgroundColor(set color: UIColor) {
        loadingView.backgroundColor = color
    }
    
    public func setBorderWidth(set width: Int) {
        self.layer.borderWidth = CGFloat(width)
    }
    
    public func setBorderColor(set color: CGColor) {
        self.layer.borderColor = color
    }
}
