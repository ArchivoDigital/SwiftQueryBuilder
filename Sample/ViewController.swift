//
//  ViewController.swift
//  Sample
//
//  Created by Hans Ospina on 1/4/17.
//  Copyright © 2017 Hans Ospina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func doLogin(_ sender: Any) {

        let q = QueryBuilder(action: .FIND, domain: 76, model: "store", page: 1, size: 10)

        if let _ = q.addCondition(obj: QueryBuilder.Condition(andOr: .AND, field: "name", op: .LIKE, value: "%a"))?.compile() {
        }

        let q2 = QueryBuilder(action: .UPDATE, domain: 76, model: "store", page: 1, size: 10)

        if let _ = q2.addObject(obj: ["name": "hans", "_KEY": "abc-def"])?.compile() {
        }

        let q3 = QueryBuilder(action: .DELETE, domain: 76, model: "store", page: 1, size: 10)

        if let _ = q3.addKey(key: "abc-def-ghi")?.compile() {
        }



        let service = DataService.sharedInstance

        service.doLogIn("grower1.ibuyflowers", password: "wpwd") { (error: NSError?, user: User?) in

            if let e = error {
                print(e.localizedDescription)
            } else {
                // tenemos usuario
                print("Email: \(user!.email)")
                print("Token: \(user!.token)")
            }

        }

    }
}

