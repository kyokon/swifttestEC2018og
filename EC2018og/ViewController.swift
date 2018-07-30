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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate {
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var results: UILabel!
    
    @IBOutlet weak var OralDataViewTable: UITableView!
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    
    var dbArray = [String]()
    
    //FIRDataEventTypeChildAdded //addchildと同じ機能持ってそう
    //要素数取れません
    
    func loadData() -> Array<Any> {
        dbArray.removeAll()
        //var fruits1 = [String]()
        var DBRefs1:DatabaseReference!
        DBRefs1 = Database.database().reference()
        DBRefs1.child("oralPresentationData3/section1").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let item = OralPresentationData3(snapshot: child as! DataSnapshot)
                print("groupid")
                print((item?.groupid)!)
                
                print("name")
                print((item?.name)!)
                
                print("body")
                print((item?.body)!)
                
                self.dbArray.append((item?.groupid)!+":"+(item?.body)!)
                print("append end")
                print(self.dbArray)
                self.OralDataViewTable.reloadData()
                
            }
        })
        return dbArray
    }
    
    @IBAction func button1(_ sender: Any) {
        //let data = ["name": "test"]
        let data = "testname"
        
        let data2 = TextField.text!
        
        var tmpchild = DBRef.child("oralPresentationData3/section1").childByAutoId()
        tmpchild.child("name").setValue(data)
        tmpchild.child("body").setValue(data2)
        tmpchild.child("reply").childByAutoId().setValue(["name": "test","body": "test"])
        
        //let data2 = ["text": TextField.text!]
       /* DBRef.child("oralPresentationData3/section1/message3/body").setValue(data2)
        
        
        DBRef.child("oralPresentationData3/section1/message3/name").setValue(data)
       
        //let data2 = ["text": TextField.text!]
        DBRef.child("oralPresentationData3/section1/message3/body").setValue(data2)
        DBRef.child("oralPresentationData3/section1/message3/reply").childByAutoId().setValue(["name": "test","body": "test"])
        */
        loadData()
        self.OralDataViewTable.reloadData()
    }
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        
        initializePullToRefresh()
        
        OralDataViewTable.dataSource = self    //追加
        OralDataViewTable.delegate = self // 追加
        
        TextField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        DBRef = Database.database().reference()
        
    }
    private func initializePullToRefresh() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(onPullToRefresh(_:)), for: .valueChanged)
        OralDataViewTable.addSubview(control)
        self.OralDataViewTable.refreshControl = control
    }
    
    @objc private func onPullToRefresh(_ sender: AnyObject) {
        loadData()
        refresh()
    }
    
    private func stopPullToRefresh() {
        if (self.OralDataViewTable.refreshControl?.isRefreshing)! {
            self.OralDataViewTable.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Data Flow
    private func refresh() {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1.0)
            DispatchQueue.main.async {
                self.completeRefresh()
            }
        }
    }
    
    private func completeRefresh() {
        stopPullToRefresh()
        OralDataViewTable.reloadData()
    }
    
    
    
    
    //表示可能な行数を決める　今の所は配列の最大数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var fruits1 = loadData()
        print("fruitscounts")
        //print(fruits1.count)
        if(dbArray.count > 10){
            return 10
        }else{
            return dbArray.count//return10とかなら行数10まで表示
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("IndexPath")
        print(indexPath.row)
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OralData", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = dbArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // アクセサリボタン（セルの右にあるボタン）がタップされた時の処理
        print("タップされたアクセサリがあるセルのindex番号: \(indexPath.row)")
    }
    
    
    
    func pullToRefresh(){
        loadData() // 先ほど1で書いたParseからデータを取る関数を呼び出す
        //self.refreshControl.endRefreshing() // データが取れたら更新を終える（くるくる回るViewを消去）
        self.OralDataViewTable.reloadData() // tableView自身を再読み込み
        print("reload finised")
    }
    
    // returnボタン押下で閉じる場合
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        TextField.text = textField.text
        return true
    }

    
    // 画面タップで閉じる場合
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

