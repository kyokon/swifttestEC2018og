//
//  ViewController.swift
//  EC2018og
//
//  Created by KyokoNakajima on 2018/07/19.
//  Copyright © 2018年 KyokoNakajima. All rights reserved.
//

import UIKit
import Firebase
//import SVProgressHUD

class ViewController: UIViewController {
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var results: UILabel!
    
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    @IBAction func button1(_ sender: Any) {
        let data = ["name": TextField.text!]
        DBRef.child("messages2/01/name").setValue(data)
        let data2 = ["text": "test"]
        DBRef.child("messages2/01/text").setValue(data2)
        
        DBRef.child("oralPresentationData2").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let item = GroupData(snapshot: child as! DataSnapshot)
                    print((item?.body)!)
                    
                    let snapshots = snap as! DataSnapshot
                    let dict = snapshot.value as! [String: Any]
                    print(dict)
                    for d in dict.values {
                        print("TEST")
                        //print(d.body)
                    }
                    //print(snap.children.value("title"))
                    print(snap.children.allObjects)
                    print(snapshot.childrenCount)
                }
            }
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DBRef = Database.database().reference()
    }
    
    /*@IBAction func add(_ sender: AnyObject) {
        
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

