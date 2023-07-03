//
//  ImageListViewController.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import UIKit
import SnapKit
import SDWebImage

class ImageListViewController: UIViewController {

    // MARK: - Property

    private let viewModel: ImageListViewModel
    private let tableView = UITableView()
    private var isLoadingData = false
    private let cellSpacing: CGFloat = 10.0
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - init

    init(viewModel: ImageListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchImages()
    }

    // MARK: - private methods

    private func setupUI() {
        title = "Picture Library"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
        tableView.separatorStyle = .none
        tableView.tableFooterView = activityIndicator
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)

    }

    private func fetchImages() {
        guard !isLoadingData else { return }

        isLoadingData = true

        activityIndicator.startAnimating()

        viewModel.fetchImages { [weak self] error in
            guard let self = self else { return }

            // Add a delay of 1 second before updating isLoadingData
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoadingData = false
                self.activityIndicator.stopAnimating()

                if let error = error {
                    if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                        self.showNoInternetAlert()
                    } else {
                        self.showErrorAlert(message: error.localizedDescription)
                    }
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func showNoInternetAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfImages()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageTableViewCell
        let image = viewModel.image(at: indexPath.row)
        cell.configure(with: image)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = viewModel.image(at: indexPath.row)
        let imageUrl = image.url

        let imageDetailViewModel = ImageDetailViewModel(imageUrl: imageUrl)
        let detailViewController = ImageDetailViewController(viewModel: imageDetailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            fetchImages()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = viewModel.image(at: indexPath.row)
        let aspectRatio = CGFloat(image.width) / CGFloat(image.height)
        let targetWidth = tableView.bounds.width - 16
        let targetHeight = targetWidth / aspectRatio
        return targetHeight + 16
    }
}

extension ImageListViewController {
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
