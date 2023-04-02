//
//  ViewController.swift
//  taskapp
//
//  Created by 布団 on 2023/03/21.
//

import UIKit
import RealmSwift
import UserNotifications
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    
    // DB内のタスクが格納されるリスト。
    // 日付の近い順でソート：昇順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        SearchBar.delegate = self
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //データの数（=セルの数）を返すメゾット
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    
    //　各セルの内容を返すメゾット
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な　cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = taskArray[indexPath.row]
        let display = task.title + "(" + task.category + ")"
        
        
        
        
        
        cell.textLabel?.text = display
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        
        return cell
    }
    //各セルを選択した時に実行されるメゾット
    func tableView(_tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //セルが削除が可能な事を伝えるメゾット
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //Deleteボタンが押されたときに呼ばれるメゾット
    func tableView(_tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            // 削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            
            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            // データベースから削除する
            try! realm.write {
                self.realm.delete(task)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        }
    }
    
    
    // segue で画面遷移する時に呼ばれる
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:inputViewController = segue.destination as! inputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        // 入力された値がnilでなければif文のブロック内の処理を実行
        if let word = searchBar.text {
            // デバッグエリアに出力
            print(word)
            if word.count == 0{
                taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
                
            } else {
                taskArray = realm.objects(Task.self).where { task in
                  
                    task.category == word
                }
                
            }
          
        } else {
             taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
            
        }
        tableView.reloadData()
        
    }

 
    
    
}
