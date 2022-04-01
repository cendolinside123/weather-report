//
//  ChildContentTableViewCell.swift
//  Weather Report
//
//  Created by Jan Sebastian on 01/04/22.
//

import UIKit

class ChildContentTableViewCell: UITableViewCell {

    private let lblID: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "id: "
        return label
    }()
    
    private let lblMain: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "main: "
        return label
    }()
    
    private let lblDesc: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "description: "
        return label
    }()
    
    private let stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.layoutMargins.top = 0
        stackView.layoutMargins.right = 0
        return stackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        self.contentView.backgroundColor = .white
        setup()
    }
    
    
    private func setupOutlet() {
        contentView.addSubview(stackViewContent)
        contentView.addSubview(lblID)
        contentView.addSubview(lblDesc)
        contentView.addSubview(lblMain)
        
        stackViewContent.addArrangedSubview(lblID)
        stackViewContent.addArrangedSubview(lblDesc)
        stackViewContent.addArrangedSubview(lblMain)
        
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["stackViewContent": stackViewContent]
        let metrix: [String: Any] = [:]
        var constraints: [NSLayoutConstraint] = []
        
        // MARK: stackViewContent constraints
        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        let hStackViewContent = "H:|-5-[stackViewContent]-5-|"
        let vStackViewContent = "V:|-5-[stackViewContent]-5-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hStackViewContent, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vStackViewContent, options: .alignAllCenterX, metrics: metrix, views: views)
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setup() {
        setupOutlet()
        setupConstraints()
    }

}

extension ChildContentTableViewCell {
    func setValue(value weather: Weathers) {
        lblID.text = "\(weather.id)"
        lblMain.text = weather.main
        lblDesc.text = weather.description
    }
}
