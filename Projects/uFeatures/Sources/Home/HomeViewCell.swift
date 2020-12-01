import uCore
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewCell: UITableViewCell, Reusable {
    private(set) var disposeBag = DisposeBag()

    fileprivate var gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    fileprivate var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let star = UIImage(systemName: "star", withConfiguration: systemImageConfig)
        button.setImage(star, for: .normal)
        
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.tintColor = .init(white: 1, alpha: 0.75)
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        ImageCache.default.clearMemoryCache()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        configureLayout()
        createConstraints()
    }

    private func configureLayout() {
        contentView.addSubview(gifImageView)
        contentView.addSubview(favoriteButton)
    }

    private func createConstraints() {
        gifImageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(66)
        }
    }
}

extension Reactive where Base: HomeViewCell {
    var gifURL: Binder<String> {
        return Binder(base) { base, value in
            if let url = URL(string: value) {
                DispatchQueue.main.async {
                    base.gifImageView.kf.indicatorType = .activity
                    base.gifImageView.kf.setImage(with: url, options: [.transition(.fade(1))])
                }
            }
        }
    }

    var isFavorited: Binder<Bool> {
        return Binder(base) { base, value in
            if value {
                base.favoriteButton.backgroundColor = UIColor.blue.withAlphaComponent(0.9)
            } else {
                base.favoriteButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            }
        }
    }

    var favoriteDidTap: ControlEvent<Void> {
        return base.favoriteButton.rx.tap
    }
}

struct HomeViewCellDimensions {
    static var height: CGFloat { 200.0 }
}
