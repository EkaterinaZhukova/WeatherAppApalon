//
//  ViewController.swift
//  WeatherAppApalon
//
//  Created by Екатерина on 10/19/18./Users/ekaterina/Apalon/WeatherAppApalon/Podfile
//  Copyright © 2018 Екатерина. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    var parameters: ForecastParameter!
    
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
    
    @IBOutlet weak var value3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parameters.lat = "exit"
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

