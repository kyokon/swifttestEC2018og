//
//  groupdata.swift
//  EC2018og
//
//  Created by KyokoNakajima on 2018/07/20.
//  Copyright © 2018年 KyokoNakajima. All rights reserved.
//

import Foundation
import Firebase

class OralPresentationData3 {
    
    var ref: DatabaseReference?
    var groupid: String?
    var name: String?
    var body: String?
    var replymesseages : Array? = []
    
    init? (snapshot: DataSnapshot) {
        ref = snapshot.ref
        guard let dict = snapshot.value as? [String:Any] else { return nil }
        guard let groupid  = ref?.key  else { return nil }
        guard let name  = dict["name"] as? String  else { return nil }
        guard let body = dict["body"]  as? String else { return nil }
        guard let replymesseages = dict["reply"] as? [String:AnyObject] else { return nil }
        var repmessages : Array? = []
        
        for i in replymesseages.keys {
            repmessages?.append(i)
        }
        
        self.groupid = groupid
        self.name = name
        self.body = body
        self.replymesseages = repmessages
    }
    
}
