//
//  ImageTableViewCell.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import UIKit
import SDWebImage
import SnapKit

final class ImageTableViewCell: UITableViewCell {

    // MARK: - Properties

    private let mainImage = UIImageView()

    private var aspectRatioConstraint: Constraint?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with image: Image) {
        mainImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImage.sd_setImage(with: image.url, placeholderImage: nil, completed: nil)
        adjustImageViewAspect(with: image.width, image.height)
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(mainImage)
        mainImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }

        mainImage.contentMode = .scaleAspectFit
        mainImage.clipsToBounds = true
        mainImage.layer.cornerRadius = 20
        mainImage.layer.masksToBounds = true

        selectionStyle = .none
    }

    private func adjustImageViewAspect(with width: Int, _ height: Int) {
        let aspectRatio = CGFloat(width) / CGFloat(height)

        if let constraint = aspectRatioConstraint {
            constraint.update(offset: aspectRatio)
        } else {
            mainImage.snp.makeConstraints { make in
                aspectRatioConstraint = make.width.equalTo(mainImage.snp.height).multipliedBy(aspectRatio).constraint
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}
