//
//  Presenter.swift
//  GitHubApiApp2
//
//  Created by 滝浪翔太 on 2020/10/06.
//

import Foundation

protocol Input {
    
    func didTappedSearchButton(searchText: String)
}

protocol UserView: AnyObject {
    
    func reloadData(_ users: [SearchResult.UserData])
}

final class SearchUserViewPresenter: Input {
    
    //MARK: - Vars
    var model = UserModel()
    public weak var view: UserView!
    
    //MARK: - Function
    func didTappedSearchButton(searchText: String) {

        print("Receive " + searchText)
        model.fetchUserData(text: searchText, completion: { result in
            print("Result",  result)
            self.view.reloadData(result) // Unexpectedly found nil while implicitly unwrapping an Optional value
        })
    }
}
