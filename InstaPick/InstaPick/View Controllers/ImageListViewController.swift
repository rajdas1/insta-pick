//
//  ImageListViewController.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import UIKit

class ImageListViewController: UITableViewController, UISearchResultsUpdating {

    var viewModel: ImageListAndSearchProtocol?
    var activity: UIActivityIndicatorView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupSearch()
        setupActivityIndicator()
        setUpViewModelBindings()
        viewModel?.fetchImages()
    }

    private func setUpViewModelBindings() {
        viewModel?.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                (isLoading ?? false) ? self?.activity?.startAnimating() : self?.activity?.stopAnimating()
            }
        }
        viewModel?.error.bind { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                        self?.viewModel?.fetchImages()
                    }))
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        viewModel?.filteredImages.bind { [weak self] images in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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

// MARK: - Data source
extension ImageListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.filteredImages.value?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel?.filteredImages.value?[indexPath.row] else {
            fatalError("Couldn't find data")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ImageListCell else {
            fatalError("Couldn't dequeue")
        }
        cell.set(data, imageRepo: viewModel?.imageRepo, dateFormatter: viewModel?.dateFormatter)
        return cell
    }
}

// MARK: - Delegate
extension ImageListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel, let data = viewModel.filteredImages.value?[indexPath.row] else {
            fatalError("Couldn't find data")
        }
        let storyboard = UIStoryboard(name: "ImageView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "ImageViewController") as? ImageViewController else {
            return
        }
        let model = ImageViewModel(
            image: data,
            imageRepo: viewModel.imageRepo,
            dateFormatter: viewModel.dateFormatter
        )
        controller.viewModel = model
        searchController.dismiss(animated: true)
        navigationController?.present(controller, animated: true, completion: nil)
    }
}

// MARK: - Search
extension ImageListViewController {
    
    func setupTitle() {
        title = "InstaPick"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.red,
            .font: UIFont(name: "Noteworthy-Bold", size: 20) as Any
        ]
    }
    
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            viewModel?.filteredImages.value = viewModel?.images.value?.filter { image in
                return image.title.lowercased().contains(searchText.lowercased())
            }
        } else {
            viewModel?.filteredImages.value = viewModel?.images.value
        }
    }
}
