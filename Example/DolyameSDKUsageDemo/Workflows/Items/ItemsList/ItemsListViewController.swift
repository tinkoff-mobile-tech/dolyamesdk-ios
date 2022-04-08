//
//  ItemsListViewController.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 28.11.2021.
//

import UIKit

class ItemsListViewController: UIViewController {

    private let presenter: IItemsListViewOutput

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let toolBar = UIView()
    private let addBarButton = UIButton(type: .system)

    private var viewModel = [ItemsListCellObject]()

    // MARK: - Initializer & Deinitializer

    init(presenter: IItemsListViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View's lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        title = "Товары"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(onCloseTouched))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(onSaveTouched))

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        if #available(iOS 13.0, *) {
            toolBar.backgroundColor = .systemBackground
        } else {
            toolBar.backgroundColor = .white
        }
        view.addSubview(toolBar)
        if #available(iOS 13.0, *) {
            toolBar.backgroundColor = .systemBackground
        } else {
            toolBar.backgroundColor = .white
        }
        toolBar.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        addBarButton.addTarget(self, action: #selector(onAddTouched), for: .touchUpInside)
        addBarButton.setTitle("Добавить", for: .normal)
        toolBar.addSubview(addBarButton)
        addBarButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(12)
            make.leading.greaterThanOrEqualToSuperview().inset(12)
        }

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ItemsListCell.self, forCellReuseIdentifier: ItemsListCell.reuseIdentifier)

        presenter.onViewDidLoad()
    }

    // MARK: - Actions

    @objc private func onAddTouched() {
        presenter.onAddItem()
    }

    @objc private func onCloseTouched() {
        presenter.onClose()
    }

    @objc private func onSaveTouched() {
        presenter.onSave()
    }
}

extension ItemsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ItemsListCell.reuseIdentifier, for: indexPath) as? ItemsListCell {
            cell.configure(with: viewModel[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.remove(at: indexPath.row)
            presenter.updateModel(objects: viewModel)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ItemsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ItemsListViewController: IItemsListViewInput {
    func update(objects: [ItemsListCellObject]) {
        viewModel = objects
        tableView.reloadData()
    }
}
