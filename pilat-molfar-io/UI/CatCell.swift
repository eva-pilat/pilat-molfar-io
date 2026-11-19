//
//  CatCell.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import UIKit
import SnapKit
import Kingfisher

final class CatCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "CatCell"
    
    // MARK: - Views
    
    private let photoView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    
    // MARK: - Setup
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.kf.cancelDownloadTask()
        photoView.image = nil
    }

    func configure(_ item: CatItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        photoView.kf.setImage(
            with: item.photoURL,
            placeholder: UIImage(systemName: "cat.fill"),
            options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 56, height: 56))),
                      .scaleFactor(UIScreen.main.scale),
                      .transition(.fade(0.2))]
        )
    }
    
    // MARK: - Layout
    
    private func setupUI() {
        setupPhotoView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    private func setupPhotoView() {
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 28
        photoView.tintColor = .systemOrange
        
        contentView.addSubview(photoView)
        
        photoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10).priority(.high)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(56)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(photoView).offset(4)
            $0.leading.equalTo(photoView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.lessThanOrEqualToSuperview().inset(10)
        }
    }
}
