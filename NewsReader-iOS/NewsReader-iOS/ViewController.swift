//
//  ViewController.swift
//  NewsReader-iOS
//
//  Created by dev01 on 2017/06/13.
//  Copyright © 2017年 dev01. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController {

    //ニュース一覧データを格納する配列
    var newsDataArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ニュース情報の取得
        let requestUrl = "http://appcre.net/rss.php"
        
        //webサーバに対してHTTP通信のリクエストを出してデータを取得
        Alamofire.request(requestUrl).responseJSON{ response in
            switch response.result{
            case.success(let json):
                //JSONデータをNSDictionaryに
                let jsonDic = json as! NSDictionary
                //辞書化したjsonDicからキー値"responseData"を取り出す
                let responseData = jsonDic["responseData"] as! NSDictionary
                //responseDataからキー値"results"を取り出す
                self.newsDataArray = responseData["results"] as! NSArray
                print("\(self.newsDataArray)")
            case.failure(let error):
                print("通信エラー:\(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

