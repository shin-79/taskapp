//
//  InputViewController.swift
//  taskapp
//
//  Created by 布団 on 2023/03/21.
//

import UIKit
import RealmSwift
import UserNotifications
class inputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var schoolButton: UIButton!
    @IBOutlet weak var lessonButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    let realm = try! Realm()
    var task: Task!
    var category = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
    }
    
    @IBAction func btnAction(sender: UIButton) {
        print(sender.tag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.category
            self.realm.add(self.task, update: .modified)
            
        }
        
        
        
        setNotification(task: task)
        
        
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
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
        
        @objc func dismissKeyboard(){
            // キーボードを閉じる
            view.endEditing(true)
        }// Do any additional setup after loading the view.
        
    @IBAction func schoolButton1(_ sender: Any) {
        
        if (lessonButton.isEnabled == false)
        { lessonButton.isEnabled = true
        } else {
            lessonButton.isEnabled = false
        }
        if (playButton.isEnabled == false)
        { playButton.isEnabled = true
        } else {
            playButton.isEnabled = false
        }
        category = "学校"
    }
    
        @IBAction func lessonButton2(_ sender: Any) {
            if (schoolButton.isEnabled == false)
            { schoolButton.isEnabled = true
            } else {
                schoolButton.isEnabled = false
            }
            if (playButton.isEnabled == false)
            { playButton.isEnabled = true
            } else {
                playButton.isEnabled = false
            }
            category = "習い事"
        }
        @IBAction func playButton3(_ sender: Any) {
            if (schoolButton.isEnabled == false)
            { schoolButton.isEnabled = true
            } else {
                schoolButton.isEnabled = false
            }
            if (lessonButton.isEnabled == false)
            { lessonButton.isEnabled = true
            } else {
                lessonButton.isEnabled = false
            }
            category = "遊び"
        }
}
