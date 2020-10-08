//
//  TopViewController.swift
//  GitHubApiApp2
//
//  Created by 滝浪翔太 on 2020/10/06.
//

import UIKit

class TopViewController: UIViewController {

    //MARK: - Vars
    private var presenter = SearchUserViewPresenter()
    var userData = [SearchResult.UserData]()
    var selectedUrl: String!
    var userName: String!
    var emptyView: UIView!
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        // tableViewのcellにxibを設定
        let cellNib = UINib(nibName: "SearchUserTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        
        // searchBarの設定
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.keyboardType = .alphabet
        
        presenter.view = self
                
        navigationItem.title = "Search User"
        
        // tableViewの要素が0の時に表示するEmptyView
        let width: CGFloat = view.frame.width
        let height: CGFloat = view.frame.height
        
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.addSubview(emptyView)
        
        let emptyViewLabel = UILabel()
        emptyViewLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
        emptyViewLabel.text = "ユーザー名を入力してください"
        emptyViewLabel.textAlignment = .center
        emptyViewLabel.center = view.center
        emptyView.addSubview(emptyViewLabel)
        
        view.bringSubviewToFront(searchBar)
    }
}



//MARK: - taleView DataSource
extension TopViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchUserTableViewCell
        let userViewData = userData[indexPath.row]
        cell.userNameLabel.text = userViewData.login
        cell.avatarImageView.image = UIImage(url: userViewData.avatarUrl)
        cell.userTypeLabel.text = userViewData.type
        
        return cell
    }
}


//MARK: - tableView Delegate
extension TopViewController: UITableViewDelegate {
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let userViewData = userData[indexPath.row]
        selectedUrl = userViewData.url
        userName = userViewData.login
        performSegue(withIdentifier: "showUserDetail", sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "showUserDetail" {
            let userDetailVC: ViewController = segue.destination as! ViewController
            userDetailVC.userUrl = selectedUrl!
            userDetailVC.titleText = userName!
        }
    }
}


//MARK: - searchBar Delegate
extension TopViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        if searchBar.text!.trimmingCharacters(in: .whitespaces) == "" {
            self.blankErrorHUD()
        } else {
            guard let text = searchBar.text else {return}
            presenter.didTappedSearchButton(searchText: text)
            showProgress()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

//MARK: - Protocol UserView
extension TopViewController: UserView {
    
    func reloadData(_ users: [SearchResult.UserData]) {

        userData = users
        print(users)
        if userData == [] {
            noUserErrorHUD()
            emptyView.isHidden = false
            tableView.reloadData()
        } else {
            emptyView.isHidden = true
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            hideProgress()
        }
    }
}
