//
//  ViewController.swift
//  iTunesRSS
//
//  Created by mcs on 4/9/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top 100 Albums"
        navigationController?.navigationBar.backgroundColor = .systemBlue
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
        addViews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "cell")
        
        let postURL = URL(string: "http://dummy.restapiexample.com/api/v1/create")!
        let method = HTTPMethod.post("Some String that better work")
        let resource = ResourceObject<String>(method: method, url: postURL)
        NetworkingManager.shared.loadObject(resource: resource) { (someObject, request, err) in
            
        }
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func addViews() {
        view.addSubview(tableView)
        
        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albumCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AlbumCell else {
            return UITableViewCell()
        }
        
        if let album = viewModel.fetchAlbum(index: indexPath.row) {
            cell.setup(album: album, cache: viewModel.cache)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = viewModel.createDetailViewController(albumIndex: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
