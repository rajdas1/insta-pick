//
//  ImageListViewController.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import UIKit

class ImageListViewController: UITableViewController {

    var viewModel: ImageListViewModelProtocol?
    var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setUpViewModelBindings()
        viewModel?.fetchImages()
    }

    private func setUpViewModelBindings() {
        viewModel?.images?.bind { [weak self] images in
            self?.tableView.reloadData()
        }
        viewModel?.isLoading.bind { [weak self] isLoading in
            (isLoading ?? false) ? self?.activity?.startAnimating() : self?.activity?.stopAnimating()
        }
        viewModel?.error?.bind { [weak self] error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupActivityIndicator() {
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activity.center = view.center
        view.addSubview(activity)
    }
}

// Data source
extension ImageListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.images?.value?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = viewModel?.images?.value?[indexPath.row].title
        return cell
    }
}

