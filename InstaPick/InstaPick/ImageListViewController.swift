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
        viewModel?.images.bind { [weak self] images in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel?.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                (isLoading ?? false) ? self?.activity?.startAnimating() : self?.activity?.stopAnimating()
            }
        }
        viewModel?.error.bind { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "retry", style: .default, handler: { _ in
                        self?.viewModel?.fetchImages()
                    }))
                    alert.addAction(UIAlertAction(title: "ok", style: .default))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func refreshed(_ sender: UIRefreshControl) {
        viewModel?.fetchImages {
            DispatchQueue.main.async {
                sender.endRefreshing()
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
        viewModel?.images.value?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel?.images.value?[indexPath.row] else {
            fatalError("Couldn't find data")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ImageListCell else {
            fatalError("Couldn't dequeue")
        }
        cell.set(data, imageRepo: viewModel?.imageRepo, dateFormatter: viewModel?.dateFormatter)
        return cell
    }
}

