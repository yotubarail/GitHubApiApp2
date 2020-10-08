//
//  ProgressExtension.swift
//  GitHubApiApp2
//
//  Created by 滝浪翔太 on 2020/10/06.
//

import UIKit
import PKHUD

extension UIViewController {
    func showProgress() {
        HUD.show(.progress)
    }
    
    func hideProgress() {
        HUD.hide()
    }
    
    func noUserErrorHUD() {
        HUD.flash(.label("ユーザーが見つかりませんでした\n再検索をお願いいたします"), delay: 2)
    }
    
    func blankErrorHUD() {
        HUD.flash(.label("ユーザー名を入力してください"), delay: 2)
    }
}
