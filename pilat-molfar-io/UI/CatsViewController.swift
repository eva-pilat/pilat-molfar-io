//
//  ViewController.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import UIKit
import SnapKit

class CatsViewController: UIViewController {
    
    // MARK: - Views
    
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    
    private let repository = CatRepository()
    private var items: [CatItem] = []
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cats"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Generate", style: .plain, target: self, action: #selector(generateTapped))
        
        setupTableView()
        setupLoader()
        
        load()
    }
    
    // MARK: - UI
    
    private func setupTableView() {
        tableView.register(CatCell.self, forCellReuseIdentifier: CatCell.reuseId)
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    private func setupLoader() {
        view.addSubview(spinner)
        
        spinner.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: - Logic
    
    private func load() {
        spinner.startAnimating()
        repository.fetchCats { [weak self] items in
            guard let self else { return }
            self.items = items
            self.title = "Cats (\(items.count))"
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    // MARK: - Actions
    
    @objc private func generateTapped() {
        spinner.startAnimating()
        navigationItem.rightBarButtonItem?.isEnabled = false
        Task {
            let photoIds = await CatPhotoService.fetchPhotoIds()
            DataGenerator.generate(photoIds: photoIds) { [weak self] time in
                print("generate time \(String(format: "%.2f", time)) s, pics in pool: \(photoIds.count)")
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.load()
            }
        }
    }
}

extension CatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatCell.reuseId, for: indexPath) as! CatCell
        cell.configure(items[indexPath.row])
        return cell
    }
}
