//
//  ViewController.swift
//  taskapp
//
//  Created by 布団 on 2023/03/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //データの数（=セルの数）を返すメゾット
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    //　各セルの内容を返すメゾット
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な　cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
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
    }
}
    


