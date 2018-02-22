//
//  ViewController.swift
//  SantaTracker
//
//  Created by 藤井陽介 on 2016/12/06.
//  Copyright © 2016年 touyou. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet private weak var timeRemainingLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var activityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var presentsRemainingLabel: UILabel!
    @IBOutlet private weak var conditionIconView: UIImageView!
    
    private var mapManager: MapManager!
    private let realmManager = SantaRealmManager()
    private var notificationToken: NotificationToken?
    private var santa: Santa?
    private var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapManager = MapManager(mapView: mapView)
        
        realmManager.logIn {
            if let realm = self.realmManager.santaRealm() {
                let santas = realm.objects(Santa.self)
                if let santa = santas.first {
                    self.santa = santa
                    santa.addObserver(self)
                } else {
                    self.notificationToken = santas.addNotificationBlock {
                        _ in
                        let santas = realm.objects(Santa.self)
                        if let santa = santas.first {
                            self.notificationToken?.stop()
                            self.notificationToken = nil
                            self.santa = santa
                            santa.addObserver(self)
                        }
                    }
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let santa = object as? Santa {
            update(with: santa)
        } else if let weather = object as? Weather {
            update(weather)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func update(with santa: Santa) {
        mapManager.update(with: santa)
        let activity = santa.activity.description
        let presentsRemaining = "\(santa.presentsRemaining)"
        DispatchQueue.main.async {
            self.activityLabel.text = activity
            self.presentsRemainingLabel.text = presentsRemaining
        }
        
        guard let weatherRealm = realmManager.weatherRealm() else {
            return
        }
        weather?.removeObserver(self)
        let weatherLocation = Location(latitude: santa.currentLocation.latitude, longitude: santa.currentLocation.longitude)
        let newWeather = Weather(location: weatherLocation)
        try? weatherRealm.write {
            weatherRealm.add(newWeather)
        }
        newWeather.addObserver(self)
        weather = newWeather
    }
    
    private func update(_ weather: Weather) {
        let temperatureText: String
        let conditionIcon: UIImage
        switch weather.loadingStatus {
        case .uploading:
            temperatureText = "??"
            conditionIcon = Weather.Condition.unknown.icon
        case .processing:
            temperatureText = ".."
            conditionIcon = Weather.Condition.unknown.icon
        case .complete(temperature: let temperature, condition: let condition):
            temperatureText = "\(temperature)℃"
            conditionIcon = condition.icon
        }
        DispatchQueue.main.async {
            self.temperatureLabel.text = temperatureText
            self.conditionIconView.image = conditionIcon
        }
    }

    deinit {
        santa?.removeObserver(self)
    }

}

