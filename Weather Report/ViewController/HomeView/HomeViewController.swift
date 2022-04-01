//
//  HomeViewController.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import UIKit
import Loading
import CoreLocation
import CellTemplates

class HomeViewController: UIViewController {
    
    private var segmentMenu: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 5
        flow.minimumInteritemSpacing = 5
        flow.sectionInset = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flow)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = ListColor.abuTanggung
        return collectionView
    }()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var coreDataStack: CoreDataStack?
    private let tblWeather: UITableView = {
        let tabel = UITableView()
        tabel.backgroundColor = UIColor(white: 1, alpha: 0)
        tabel.allowsSelection = true
        tabel.bouncesZoom = false
        tabel.bounces = false
        tabel.showsVerticalScrollIndicator = false
        tabel.tableFooterView = UIView()
        tabel.rowHeight = UITableView.automaticDimension
        tabel.estimatedRowHeight = 100
        tabel.register(ParentContentTableViewCell.self, forCellReuseIdentifier: "parentDataCell")
        return tabel
    }()
    private let loadingView = LoadingView()
    private var weatherViewModel: WeatherVMGuideline?
    private var authViewModel: AuthVMGuideline?
    private var listControll: ListUIGuideHelper?
    
    private var userInfo: UserInfo?
    private var menu: [ListMenu] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Weather Info"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.view.backgroundColor = ListColor.abuTanggung
        addLayout()
        addConstraints()
        setupSegmentMenu()
        setupTabel()
        
        if let crData = coreDataStack {
            weatherViewModel = WeatherViewModel(useCase: WeatherUseCase(weatherOnlineRequest: WeathersDataProvider(), userLocalData: UserDataSource(cdStack: crData), locationLocalData: LocationDataSource(cdStack: crData)))
            authViewModel = AuthViewModel(useCase: UserDataSource(cdStack: crData))
        }
        userInfo = UserSession.getUser()
        listControll = ListItemControll(controller: self)
        bind()
        if let getUserInfo = userInfo {
            if getUserInfo.isGuest {
                menu = [ListMenu.logout]
            } else {
                menu = [ListMenu.deleteacount, ListMenu.logout]
            }
            
            setupGPS()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                if let crData = self?.coreDataStack {
                    let loginVC = LoginViewController(page: .login, coredata: crData)
                    let nav = UINavigationController(rootViewController: loginVC)
                    UIApplication.shared.windows.first?.rootViewController = nav
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
                
            })
        }
        
        
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(coredata cdStack: CoreDataStack) {
        self.init(nibName: nil, bundle: nil)
        self.coreDataStack = cdStack
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func bind() {
        weatherViewModel?.errorReponse = { error in
            print("weatherViewModel: \(error.localizedDescription)")
        }
        
        weatherViewModel?.dataResponse = { [weak self] _ in
            print("dataResponse \(self?.weatherViewModel?.listData.count ?? 0)")
            DispatchQueue.main.async {
                self?.tblWeather.reloadData()
                self?.listControll?.hideLoading(completion: nil)
            }
            
        }
        
        weatherViewModel?.cacheResponse = { [weak self] _ in
            print("cacheResponse \(self?.weatherViewModel?.listData.count ?? 0)")
            DispatchQueue.main.async {
                self?.tblWeather.reloadData()
            }
        }
        
        authViewModel?.authResponse = { [weak self] _ in
            DispatchQueue.main.async {
                if let crData = self?.coreDataStack {
                    self?.authViewModel?.logout()
                    let loginVC = LoginViewController(page: .login, coredata: crData)
                    let nav = UINavigationController(rootViewController: loginVC)
                    UIApplication.shared.windows.first?.rootViewController = nav
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
        
    }
    
    private func addLayout() {
        self.view.addSubview(segmentMenu)
        setLoadingView()
        view.addSubview(tblWeather)
    }
    
    private func addConstraints() {
        let views: [String: Any] = ["segmentMenu": segmentMenu,"tblWeather": tblWeather, "loadingView": loadingView]
        let metrix: [String: Any] = [:]
        var constraints: [NSLayoutConstraint] = []
        
        // MARK: segmentMenu, tblPost, and loadingView constraints
        segmentMenu.translatesAutoresizingMaskIntoConstraints = false
        tblWeather.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let hSegmentMenu = "H:|-[segmentMenu]-|"
        let hTblWeather = "H:|-[tblWeather]-|"
        let vPrimaryContent = "V:|-[segmentMenu]-0-[loadingView]-0-[tblWeather]-0-|"
        let hLoadingView = "H:|-0-[loadingView]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hTblWeather, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hSegmentMenu, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vPrimaryContent, options: .alignAllCenterX, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hLoadingView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: segmentMenu, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.8/9, constant: 0)]
        let loadingViewHeight = NSLayoutConstraint(item: loadingView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)
        loadingViewHeight.identifier = "loadingViewHeight"
        constraints += [loadingViewHeight]
        
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setLoadingView() {
        loadingView.startAnimate()
        view.addSubview(loadingView)
    }
    
    private func setupTabel() {
        tblWeather.delegate = self
        tblWeather.dataSource = self
    }
    
    private func setupSegmentMenu() {
        segmentMenu.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        segmentMenu.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: "segmentCell")
        segmentMenu.delegate = self
        segmentMenu.dataSource = self
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentCell", for: indexPath) as? BasicCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        }
        cell.setValue(menu: menu[indexPath.item].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menu[indexPath.item] == .logout {
            if let crData = self.coreDataStack {
                authViewModel?.logout()
                let loginVC = LoginViewController(page: .login, coredata: crData)
                let nav = UINavigationController(rootViewController: loginVC)
                UIApplication.shared.windows.first?.rootViewController = nav
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        } else if menu[indexPath.item] == .deleteacount {
            if let getSelf = userInfo {
                authViewModel?.deleteUser(user: getSelf)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width) / 3.5
        
        return CGSize(width: Int(width), height: Int(width))
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel?.listData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "parentDataCell", for: indexPath) as? ParentContentTableViewCell else {
            return UITableViewCell()
        }
        
        if let getData = weatherViewModel?.listData[indexPath.row] {
            cell.setValue(value: getData)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        } else {
            return UITableViewCell()
        }
        
        
        return cell
    }
    
    
}

extension HomeViewController {
    
    func getLoadingView() -> LoadingView {
        return loadingView
    }
    
    private func setupGPS() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func generateData(lat getLat: Double, lon getLon: Double) {
        if let getUserInfo = userInfo {
            weatherViewModel?.getWeather(lat: getLat, lon: getLon, exclude: [], user: getUserInfo, reload: 3)
        }
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let locValue: CLLocationCoordinate2D? = manager.location?.coordinate
            print("locations = \(locValue?.latitude ?? 0) \(locValue?.longitude ?? 0)")
        
        if let getLocVal = locValue {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            generateData(lat: getLocVal.latitude, lon: getLocVal.longitude)
        }
    }
}
