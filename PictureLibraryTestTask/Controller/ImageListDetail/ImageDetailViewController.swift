//
//  ImageDetailViewController.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import UIKit
import SnapKit
import SDWebImage
class ImageDetailViewController: UIViewController {

    // MARK: - Properties

    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private var viewModel: ImageDetailViewModel

    // MARK: - init

    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setButtonNavigation()
    }

    // MARK: - Private methods

    private func setupUI() {
        title = "Picture"
        view.backgroundColor = .white

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }

        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        scrollView.layer.cornerRadius = 20

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
    }

    private func bindViewModel() {
        guard let imageUrl = viewModel.imageUrl else { return }

        imageView.sd_setImage(with: imageUrl) { [weak self] (image, error, _, _) in
            if let error = error {
                print("Failed to load image: \(error)")
            } else {
                self?.imageView.image = image
                self?.resizeImageViewToFitScreen(image: image)
            }
        }
    }

    private func resizeImageViewToFitScreen(image: UIImage?) {
        guard let image = image else { return }

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let contentWidth = screenWidth - 16
        let contentHeight = screenHeight - 16

        let scale = min(contentWidth / image.size.width, contentHeight / image.size.height)
        let scaledSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        imageView.frame = CGRect(origin: .zero, size: scaledSize)
        scrollView.contentSize = scaledSize
    }

    private func setButtonNavigation() {
        let customBackButton = UIButton(type: .system)
        customBackButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        customBackButton.tintColor = .black
        customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let customBarButtonItem = UIBarButtonItem(customView: customBackButton)

        navigationItem.leftBarButtonItem = customBarButtonItem
    }

    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    // MARK: - Action @objc

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            let zoomRect = zoomRectForScale(scrollView.maximumZoomScale, center: gesture.location(in: imageView))
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
