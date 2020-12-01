import uCore
import UIKit
import RxSwift
import SnapKit

final class HomeView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(HomeViewCell.self)        
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor.white
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        configureLayout()
        createConstraints()
    }

    private func configureLayout() {        
        addSubview(tableView)
    }

    private func createConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
