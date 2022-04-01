//
//  SetupViewController.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import UIKit

class SetupViewController: UIViewController {
    
    private let imageWeather: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "weather")
        return imageView
    }()
    
    private let lblTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(46)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.text = "Weather Report"
        return label
    }()
    
    private let lblInitialize: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.text = "Initialize..."
        label.textAlignment = .center
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = ListColor.biruLumut
        setupOutlet()
        setupConstraints()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func setupOutlet() {
        self.view.addSubview(imageWeather)
        self.view.addSubview(lblTitle)
        self.view.addSubview(lblInitialize)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["imageWeather": imageWeather, "lblTitle": lblTitle, "lblInitialize": lblInitialize]
        let matrix: [String: Any] = [:]
        var contraints: [NSLayoutConstraint] = []
        
        
        // MARK: imageWeather and lblTitle constraints
        imageWeather.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let vPrimaryLayout = "V:|-100-[imageWeather]-50-[lblTitle]"
        contraints += NSLayoutConstraint.constraints(withVisualFormat: vPrimaryLayout, options: .alignAllCenterX, metrics: matrix, views: views)
        contraints += [NSLayoutConstraint(item: imageWeather, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/2, constant: 0)]
        contraints += [NSLayoutConstraint(item: lblTitle, attribute: .leading, relatedBy: .equal, toItem: imageWeather, attribute: .leading, multiplier: 1, constant: 0)]
        contraints += [NSLayoutConstraint(item: lblTitle, attribute: .trailing, relatedBy: .equal, toItem: imageWeather, attribute: .trailing, multiplier: 1, constant: 0)]
        contraints += [NSLayoutConstraint(item: imageWeather, attribute: .height, relatedBy: .equal, toItem: imageWeather, attribute: .width, multiplier: 1, constant: 0)]
        
        // MARK: lblInitialize constraints
        lblInitialize.translatesAutoresizingMaskIntoConstraints = false
        contraints += [NSLayoutConstraint(item: lblInitialize, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)]
        contraints += [NSLayoutConstraint(item: lblInitialize, attribute: .leading, relatedBy: .equal, toItem: imageWeather, attribute: .leading, multiplier: 1, constant: 0)]
        contraints += [NSLayoutConstraint(item: lblInitialize, attribute: .trailing, relatedBy: .equal, toItem: imageWeather, attribute: .trailing, multiplier: 1, constant: 0)]
        contraints += [NSLayoutConstraint(item: lblInitialize, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50)]
        
        
        NSLayoutConstraint.activate(contraints)
    }

}
