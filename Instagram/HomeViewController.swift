//
//  HomeViewController.swift
//  Instagram
//
//  Created by 理化学Mac on 2018/07/28.
//  Copyright © 2018年 yuusukesaito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var postArrey: [PostData] = []
    var observing = false
    //編集されたコメント
    var commentData = ""
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEBUG_PRINT: viewWillAppear")
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: {snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArrey.insert(postData, at: 0)
                        self.tableView.reloadData()
                    }
                })
                
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        var index: Int = 0
                        for post in self.postArrey {
                            if post.id == postData.id {
                                index = self.postArrey.index(of: post)!
                                break
                            }
                        }
                        self.postArrey.remove(at: index)
                        self.postArrey.insert(postData, at: index)
                        self.tableView.reloadData()
                    }
                })
                observing = true
            }
        } else {
            if observing == true {
                postArrey = []
                tableView.reloadData()
                Database.database().reference().removeAllObservers()
                observing = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArrey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArrey[indexPath.row])
        cell.likeButton.addTarget(self, action: #selector(hundleButton(_:forEvent:)), for: .touchUpInside)
        //コメントボタンアクションの設定
        cell.commentButton.addTarget(self, action: #selector(hundleCommentButton(_:forEvent:)), for: .touchUpInside)
        print("設定されたよ")
        return cell
    }
    
    
    
    @objc func hundleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました")
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let postData = postArrey[indexPath!.row]
        
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
        }
    }
    
    @objc func hundleCommentButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: commentボタンがタップされました")
        //タップされたセルを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        //配列からタップされたインデックスデータを取り出す
        let postData = postArrey[indexPath!.row]
        temp = indexPath!.row
        let uid = Auth.auth().currentUser?.uid
        postData.commentButton.append(uid!)
        //CommentViewControllerへ遷移
        let storyboard: UIStoryboard = self.storyboard!
        let commentView = storyboard.instantiateViewController(withIdentifier: "Comment")
        self.present(commentView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //CommentViewControllerから戻ってきたら呼ばれる
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        let name = Auth.auth().currentUser!.displayName
        let message = "\(commentData) :\(name!)"
        let postData = postArrey[temp]
        if commentData != "" {
            postData.comment.append(message)
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let comment = ["comment": postData.comment]
            postRef.updateChildValues(comment)
            print("\(String(describing: name))")
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
