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
extension MapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation is MKUserLocation){
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.frame = CGRect(x: 0, y: 0, width: 100, height: 190)
        pinView!.canShowCallout = true
        pinView!.animatesDrop = true
        let placesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 180, height: 150))
        placesTableView.rowHeight = 50
        placesTableView.dataSource = self
        placesTableView.delegate = self
       
        pinView?.addSubview(placesTableView)
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("select")
    }
}
class MapVC: UIViewController{
    var placeData = [String]()
    var weatherArr = [Weather]()
    @IBOutlet weak var worldMapView: MKMapView!
    var parameters: ForecastParameter?
    override func viewDidLoad() {
        super.viewDidLoad()
        worldMapView.delegate = self
        addGesture()
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
                        for i in 0...2{
                            let wr = Weather(data: degree[i])
                            self?.weatherArr.append(wr)
                        }
                    }
                    if let city = dic["city"] as? [AnyHashable: Any]{
                        let name = city["name"] as? String
                        print(name)
                        print(self?.weatherArr.count)
                    }
                    self?.worldMapView.addAnnotation(ann)
                    
                    
                }else {
                    print(result.error)
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
}

