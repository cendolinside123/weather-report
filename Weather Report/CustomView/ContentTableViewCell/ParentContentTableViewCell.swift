//
//  ParentContentTableViewCell.swift
//  Weather Report
//
//  Created by Jan Sebastian on 01/04/22.
//

import UIKit

class ParentContentTableViewCell: UITableViewCell {
    
    private var listWeather: [Weathers] = []
    
    private let stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.layoutMargins.top = 0
        stackView.layoutMargins.right = 0
        return stackView
    }()
    
    private let stackInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.layoutMargins.left = 0
        stackView.layoutMargins.right = 0
        return stackView
    }()
    
    private let lblLat: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "lat: "
        return label
    }()
    
    private let lblLon: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "lon: "
        return label
    }()
    
    private let lblTimezone: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "timezone: "
        label.font = label.font.withSize(10)
        return label
    }()
    
    private let lblPressure: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "pressure: "
        return label
    }()
    
    private let lblHumidity: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "humidity: "
        return label
    }()
    
    private let lblWind_speed: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "wind speed: "
        return label
    }()
    
    private let lblCategory: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "Category: "
        return label
    }()
    
    private let tblWeather: UITableView = {
        let tabel = BootstrapTableView()
        tabel.backgroundColor = UIColor(white: 1, alpha: 0)
        tabel.allowsSelection = true
        tabel.bouncesZoom = false
        tabel.bounces = false
        tabel.showsVerticalScrollIndicator = false
        tabel.tableFooterView = UIView()
        tabel.register(ChildContentTableViewCell.self, forCellReuseIdentifier: "weatherInfoCell")
        tabel.separatorStyle = .none
        return tabel
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
    
    
    private func setupOutelt() {
        contentView.addSubview(stackViewContent)
        contentView.addSubview(stackInfo)
        contentView.addSubview(lblLat)
        contentView.addSubview(lblLon)
        contentView.addSubview(lblTimezone)
        contentView.addSubview(lblPressure)
        contentView.addSubview(lblHumidity)
        contentView.addSubview(lblWind_speed)
        contentView.addSubview(lblCategory)
        contentView.addSubview(tblWeather)
        
        stackInfo.addArrangedSubview(lblLat)
        stackInfo.addArrangedSubview(lblLon)
        stackInfo.addArrangedSubview(lblTimezone)
        stackInfo.addArrangedSubview(lblPressure)
        stackInfo.addArrangedSubview(lblHumidity)
        stackInfo.addArrangedSubview(lblWind_speed)
        stackInfo.addArrangedSubview(lblCategory)
        
        stackViewContent.addArrangedSubview(stackInfo)
        stackViewContent.addArrangedSubview(tblWeather)
    }

    private func setupConstraint() {
        let views: [String: Any] = ["stackViewContent": stackViewContent, "tblWeather": tblWeather]
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
        
        setupOutelt()
        setupConstraint()
        setupTabel()
    }
    
    private func setupTabel() {
        tblWeather.delegate = self
        tblWeather.dataSource = self
    }
    
}
extension ParentContentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherInfoCell", for: indexPath) as? ChildContentTableViewCell else {
            return UITableViewCell()
        }
        cell.setValue(value: listWeather[indexPath.row])
        return cell
    }
    
    
}

extension ParentContentTableViewCell {
    func setValue(value data: CurrentLocation) {
        lblLon.text = "\(data.lon)"
        lblLat.text = "\(data.lat)"
        lblHumidity.text = "\(data.humidity)"
        lblPressure.text = "\(data.pressure)"
        lblTimezone.text = "\(data.timezone)"
        lblWind_speed.text = "\(data.wind_speed)"
        lblCategory.text = data.category
        listWeather = data.weathers
        tblWeather.reloadData()
    }
}


