//
//  detailViewController.swift
//  thatFood
//
//  Created by Darshan Patel on 02/01/18.
//  Copyright © 2018 Darshan Patel. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    var data: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    let parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts",
        "exintro" : "",
        "explaintext" : "",
      //  "titles" : flowerName,
        "indexpageids" : "",
        "redirects" : "1",
        ]


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
