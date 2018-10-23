//
//  ViewController.swift
//  WeatherAppApalon
//
//  Created by Екатерина on 10/19/18./Users/ekaterina/Apalon/WeatherAppApalon/Podfile
//  Copyright © 2018 Екатерина. All rights reserved.
//

import UIKit
import MapKit
import Moya
import RealmSwift

let kShowDetail = "kShowDetail"
struct ForecastParameter{
    var lat = ""
    var lon = ""
    let aPPID = "3c7c6440876f63db87401b8ac41ee0d6"
    
}
extension MapVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "id")
        cell.textLabel?.text = String(weatherArr[indexPath.row].temp!)
        cell.detailTextLabel?.text = weatherArr[indexPath.row].main
        let data = try? Data(contentsOf: URL(string: "http://openweathermap.org/img/w/\(weatherArr[indexPath.row].icon!).png")!)
        print( "http://openweathermap.org/img/w/\(weatherArr[indexPath.row].icon!).png")
        if(data != nil){
            let image = UIImage(data: data!)
            cell.imageView?.image = image
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        
        let pinView: MKPinAnnotationView
        if let reusedPinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView {
            reusedPinView.annotation = annotation
            pinView = reusedPinView
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView.leftCalloutAccessoryView = nil
        pinView.rightCalloutAccessoryView = nil
        pinView.canShowCallout = true
        pinView.animatesDrop = true
        
        let placesTableView = UITableView()
        placesTableView.rowHeight = 50
        placesTableView.dataSource = self
        placesTableView.delegate = self

        let widthConstraint = NSLayoutConstraint(item: placesTableView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 180)
        placesTableView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: placesTableView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 150)
        placesTableView.addConstraint(heightConstraint)
        
        pinView.detailCalloutAccessoryView = placesTableView
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("select")
    }
    
}
class MapVC: UIViewController{
    var placeData = [String]()
    var weatherArr = [Weather]()
    let realm = try! Realm()
    @IBOutlet weak var worldMapView: MKMapView!
    var parameters: ForecastParameter?
    override func viewDidLoad() {
        super.viewDidLoad()
        worldMapView.delegate = self
        addGesture()
        
//        let weathers = realm.objects(WeatherModel.self)
//        for item in weathers{
//            print(item)
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addGesture(){
        let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.gestureRecognizerShouldBegin));
        tapRecognizer.minimumPressDuration = 2;
        worldMapView.addGestureRecognizer(tapRecognizer);
    }
    
    
    
    @objc func gestureRecognizerShouldBegin(gestureRecognizer:UIGestureRecognizer) -> Bool{
        if gestureRecognizer.state == .began{
            worldMapView.removeAnnotations(worldMapView.annotations)
            let point = gestureRecognizer.location(in: worldMapView)
            let tapPoint = worldMapView.convert(point, toCoordinateFrom: view)
            let ann = MKPointAnnotation()
            ann.title = "Tittle"
            ann.coordinate = tapPoint
            weatherArr.removeAll()
            worldMapView.removeAnnotations(worldMapView.annotations)
            parameters = ForecastParameter(lat: String(tapPoint.latitude), lon: String(tapPoint.longitude))
            openWeatherProvider.request(.forecast(parameters: ForecastParameter(lat: "\(ann.coordinate.latitude)", lon: "\(ann.coordinate.longitude)"))){[weak self](result) in
                if case let .success(response) = result {
                    let jsonString = try? response.mapJSON()
                    guard let  dic = jsonString as? [AnyHashable: Any] else { return }
                    
                    if let degree = dic["list"] as? [Any]{
                        for i in 0...4{
                            let wr = Weather(data: degree[i])
                            self?.weatherArr.append(wr)
                            let model = WeatherModel.init(weather: wr)
                            try! self?.realm.write {
                                self?.realm.add(model)
                            }
                       }
                    }
                    self?.worldMapView.addAnnotation(ann)
                }else {
                    print(result.error!)
                }
                
            }
            
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowDetail{
            guard let detailVC = segue.destination as? DetailVC, let param = self.parameters else{
                return;
            }
            detailVC.parameters = param
        }
    }
    
    @IBAction func clearHistory(_ sender: Any) {
        try! realm.write {
            realm.delete(realm.objects(WeatherModel.self))
        }
    }
    
}

