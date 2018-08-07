//
//  PostData.swift
//  Instagram
//
//  Created by 理化学Mac on 2018/07/30.
//  Copyright © 2018年 yuusukesaito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    ///コメントの追加
    var comment: [String] = []
    ///コメント展開ボタンの設定
    var commentOpenButton: [String] = []
    ///コメントのボタン
    var commentButton: [String] = []
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        let valueDictionary = snapshot.value as! [String: Any]
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        self.name = valueDictionary["name"] as? String
        self.caption = valueDictionary["caption"] as? String
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        //コメントの追加
        if let comment = valueDictionary["comment"] as? [String] {
            self.comment = comment
        }
        //コメントボタンの追加
        if let commentButton = valueDictionary["commentButton"] as? [String] {
            self.commentButton = commentButton
        }
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
    }
    
}
