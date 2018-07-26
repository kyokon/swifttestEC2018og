//
//  groupdata.swift
//  EC2018og
//
//  Created by KyokoNakajima on 2018/07/20.
//  Copyright © 2018年 KyokoNakajima. All rights reserved.
//

import Foundation
import Firebase

class GroupData {
    
    var ref: DatabaseReference?
    var groupid: String?
    var number: String?
    var body: String?
    var title: String?
    var whois: String?
    
    init? (snapshot: DataSnapshot) {
        ref = snapshot.ref
        guard let dict = snapshot.value as? [String:Any] else { return nil }
        guard let groupid  = ref?.key  else { return nil }
        guard let number  = dict["number"] as? String  else { return nil }
        guard let body = dict["body"]  as? String else { return nil }
        guard let title = dict["title"]  as? String else { return nil }
        guard let whois = dict["whois"]  as? String else { return nil }
        
        self.groupid = groupid
        self.number = number
        self.body = body
        self.title = title
        self.whois = whois
        
        
    }
    
}
