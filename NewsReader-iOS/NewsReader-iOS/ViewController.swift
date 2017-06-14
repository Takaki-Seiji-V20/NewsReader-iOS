//
//  ViewController.swift
//  NewsReader-iOS
//
//  Created by dev01 on 2017/06/13.
//  Copyright © 2017年 dev01. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{

    //ニュース一覧データを格納する配列
    var newsDataArray = NSArray()
    
    @IBOutlet var table :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table viewのDataSource参照先指定
        table.dataSource = self
        //Table viewのタップ時のdelegate先を指定
        table.delegate = self
        
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
                //ニュース記事を取得したらテーブルビューに表示
                self.table.reloadData()
                
            case.failure(let error):
                print("通信エラー:\(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //セルに表示する内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboardで取得したcellを取得
        let cell = UITableViewCell(style:UITableViewCellStyle.subtitle,reuseIdentifier:"Cell")
        //ニュース記事データを取得(配列の"indexPath.row"番目の要素を取得)
        let newsDic = newsDataArray[indexPath.row] as! NSDictionary
        cell.textLabel!.text = newsDic["title"] as? String
        cell.textLabel!.numberOfLines = 3
        cell.detailTextLabel!.text = newsDic["publishedDate"] as? String
        
        return cell
    }
    
    //テーブルビューのせるの数をnewsDataArrayに格納しているデータの数で設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return newsDataArray.count
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルのインデックスパス番号の出力
        print("タップされたセルのインデックスパス :\(indexPath.row)")
        //ニュース記事のデータを取得(配列の要素で"indexPath.row"番目の要素を取得)
        let newsDic = newsDataArray[indexPath.row] as! NSDictionary
        //ニュース記事のURLを取得
        let newsUrl = newsDic["unescapedUrl"] as! String
        //StringをURLに変換
        let url = URL(string:newsUrl)
        //UIApplocation インスタンス作成
        UIApplication.shared.openURL(url!)
        //openURLメソッドでURLを引数にWEBブラウザSafariを起動
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 50
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // アクセサリボタン（セルの右にあるボタン）がタップされた時の処理
        print("タップされたアクセサリがあるセルのindex番号: \(indexPath.row)")
    }
}

