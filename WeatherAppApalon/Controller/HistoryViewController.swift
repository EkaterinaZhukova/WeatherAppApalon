//
//  HistoryViewController.swift
//  WeatherAppApalon
//
//  Created by Екатерина on 10/22/18.
//  Copyright © 2018 Екатерина. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UITableViewController {

    let reuseCellId = "dataBaseId"
    var weatherArr = [Weather]()
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue(label: "realm",qos: .utility).async {[weak self] in
            let realm = try! Realm()
            let modelArray = realm.objects(WeatherModel.self)
            for i in (0 ..< modelArray.count).reversed(){
                self?.weatherArr.append(Weather(weatherModel: modelArray[i]))
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseCellId)
        let data = try? Data(contentsOf: URL(string: "http://openweathermap.org/img/w/\(weatherArr[indexPath.row].icon!).png")!)
        if(data != nil){
            let image = UIImage(data: data!)
            cell.imageView?.image = image
        }
        cell.textLabel?.text = "\(weatherArr[indexPath.row].temp!.rounded())˚C - \(String(describing: weatherArr[indexPath.row].city!))"
        cell.detailTextLabel?.text = weatherArr[indexPath.row].dateTime
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
