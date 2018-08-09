//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 理化学Mac on 2018/07/30.
//  Copyright © 2018年 yuusukesaito. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    //commentLabelの追加
    @IBOutlet weak var commentLabel: UILabel!
    //commentButtonの追加
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        self.postImageView.image = postData.image
        self.captionLabel.text = "\(postData.name!): \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        //commentlabelの表示
        var commentText =  ""
        for c in postData.comment {
             commentText += "\(c)\n"
        }
        self.commentLabel.text = commentText
        
        //commentButtonの設定
        self.commentButton.setTitle("コメント", for: .normal)
        self.commentButton.setTitleColor(UIColor.black, for: .normal)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}

