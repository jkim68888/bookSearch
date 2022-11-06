//
//  BookListViewController.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import UIKit

class BookListViewController: UIViewController {
	// MARK: - ViewModel
	private var viewModel: BooksListViewModel!

	// MARK: - UI
	private lazy var bookSearchView: UIView = {
		let view = UIView()
		view.addSubview(bookSearchTextField)
		view.addSubview(bookSearchDoneButton)
		return view
	}()

	private lazy var bookSearchTextField: UITextField = {
		var tf = UITextField()
		tf.backgroundColor = .clear
		tf.textColor = .black
		tf.tintColor = .black
		tf.autocapitalizationType = .none
		tf.autocorrectionType = .no
		tf.spellCheckingType = .no
		tf.returnKeyType = .search
		tf.layer.cornerRadius = 8
		tf.layer.borderWidth = 1
		tf.layer.borderColor = UIColor.gray.cgColor
		tf.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
		tf.addLeftPadding()
		tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
		return tf
	}()
	
	private lazy var bookSearchDoneButton: UIButton = {
		var btn = UIButton()
		btn.backgroundColor = .blue
		btn.setTitle("찾기", for: .normal)
		btn.setTitleColor(.white, for: .normal)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		btn.layer.cornerRadius = 6
		btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
		return btn
	}()
	
	private var booksListTableView = UITableView()
	
	static func create(with viewModel: BooksListViewModel) -> BookListViewController {
		let view = BookListViewController()
		view.viewModel = viewModel
		return view
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		// ui
		configure()
		setupAutoLayout()
		// vm
		bind(to: viewModel)
		viewModel.viewDidLoad()
    }
    
	private func configure() {
		bookSearchTextField.delegate = self
		
		booksListTableView.delegate = self
		booksListTableView.dataSource = self
		booksListTableView.register(BooksListItemCell.self, forCellReuseIdentifier: BooksListItemCell.identifier)
		
		view.backgroundColor = .white
		self.navigationController?.navigationBar.topItem?.title = "책 찾기"
		view.addSubview(bookSearchView)
		view.addSubview(booksListTableView)
	}
	
	// 오토레이아웃
	private func setupAutoLayout() {
		bookSearchView.translatesAutoresizingMaskIntoConstraints = false
		bookSearchView.heightAnchor.constraint(equalToConstant: 48).isActive = true
		bookSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
		bookSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
		bookSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
		
		bookSearchTextField.translatesAutoresizingMaskIntoConstraints = false
		bookSearchTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
		bookSearchTextField.leadingAnchor.constraint(equalTo: bookSearchView.leadingAnchor).isActive = true
		bookSearchTextField.trailingAnchor.constraint(equalTo: bookSearchDoneButton.leadingAnchor, constant: -10).isActive = true
		bookSearchTextField.centerYAnchor.constraint(equalTo: bookSearchView.centerYAnchor).isActive = true
		
		bookSearchDoneButton.translatesAutoresizingMaskIntoConstraints = false
		bookSearchDoneButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
		bookSearchDoneButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
		bookSearchDoneButton.leadingAnchor.constraint(equalTo: bookSearchTextField.trailingAnchor, constant: 10).isActive = true
		bookSearchDoneButton.trailingAnchor.constraint(equalTo: bookSearchView.trailingAnchor).isActive = true
		bookSearchDoneButton.centerYAnchor.constraint(equalTo: bookSearchView.centerYAnchor).isActive = true
		
		booksListTableView.translatesAutoresizingMaskIntoConstraints = false
		booksListTableView.topAnchor.constraint(equalTo: bookSearchView.bottomAnchor, constant: 20).isActive = true
		booksListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		booksListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		booksListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		booksListTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	// MARK: - Bind Data
	private func bind(to viewModel: BooksListViewModel) {
		viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
		viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
	}
	
	private func updateItems() {
		booksListTableView.reloadData()
		
		// 검색된 책 총 수량 표시
		print("책 수량 : \(viewModel.totalPageCount)")
	}
	
	private func showError(_ error: String) {
		guard !error.isEmpty else { return }
		let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc private func doneButtonTapped(_ textField: UITextField) {
		viewModel.didSearch(searchText: bookSearchTextField.text ?? "")
	}

}

// MARK: - TextField Delegate
extension BookListViewController: UITextFieldDelegate {

	@objc private func textFieldEditingChanged(_ textField: UITextField) {
		
	}

	// 엔터 누르면 일단 키보드 내림
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}

// MARK: - UITableView Delegate, DataSource
extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.items.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: BooksListItemCell.identifier, for: indexPath) as? BooksListItemCell else { return UITableViewCell() }
		
		cell.binding(with: viewModel.items.value[indexPath.row])
		
		if indexPath.row == viewModel.items.value.count - 1 {
			viewModel.didLoadNextPage()
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didSelectItem(at: indexPath.row)
	}
	
}
