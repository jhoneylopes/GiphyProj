import uCore
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class FavoritesViewCell: UICollectionViewCell, Reusable {
    private(set) var disposeBag = DisposeBag()

    fileprivate var gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    fileprivate var unfavoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let star = UIImage(systemName: "trash", withConfiguration: systemImageConfig)
        button.setImage(star, for: .normal)
        button.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        button.tintColor = .init(white: 1, alpha: 0.75)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()        
    }

    private func setup() {
        configureLayout()
        createConstraints()
    }

    private func configureLayout() {
        contentView.addSubview(gifImageView)
        contentView.addSubview(unfavoriteButton)
    }

    private func createConstraints() {
        gifImageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }

        unfavoriteButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
    }
}

extension Reactive where Base: FavoritesViewCell {
    var gifURL: Binder<String> {
        return Binder(base) { base, value in
            if let url = URL(string: value) {
                ImageCache.default.memoryStorage.config.totalCostLimit = 1
                base.gifImageView.kf.indicatorType = .activity
                base.gifImageView.kf.setImage(with: url,
                                              options: [.transition(.fade(1))])
            }
        }
    }

    var unfavoriteDidTap: ControlEvent<Void> {
        return base.unfavoriteButton.rx.tap
    }
}
