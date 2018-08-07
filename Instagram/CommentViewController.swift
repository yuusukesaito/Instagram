//
//  CommentViewController.swift
//  Instagram
//
//  Created by 理化学Mac on 2018/08/05.
//  Copyright © 2018年 yuusukesaito. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTexField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //遷移先のHomeViewControllerを取得
        let commentText:HomeViewController = segue.destination as! HomeViewController
        //HomeViewControllerで宣言しているcommentにテキストの文字列を代入し渡す
        commentText.commentData = self.commentTexField.text!
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
