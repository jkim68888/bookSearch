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
		tf.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
		return tf
	}()
	
	private lazy var bookSearchDoneButton: UIButton = {
		var btn = UIButton()
		btn.backgroundColor = .systemGray2
		btn.setTitle("찾기", for: .normal)
		btn.setTitleColor(.white, for: .normal)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		btn.layer.cornerRadius = 6
		btn.isEnabled = false
		btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
		return btn
	}()
	
	private let bookCountLabel: UILabel = {
		var lbl = UILabel()
		
		return lbl
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
		
		if bookSearchTextField.accessibilityPerformMagicTap() {
			bookSearchTextField.becomeFirstResponder()
		}
		
		// for unit test
		bookSearchTextField.accessibilityIdentifier = "bookSearchAccessIdentifier"
		
		booksListTableView.delegate = self
		booksListTableView.dataSource = self
		booksListTableView.register(BooksListItemCell.self, forCellReuseIdentifier: BooksListItemCell.identifier)
		booksListTableView.rowHeight = 120
		
		// for unit test
		booksListTableView.accessibilityIdentifier = "bookTableViewAccessIdentifier"
		
		view.backgroundColor = .white
		self.navigationController?.navigationBar.topItem?.title = "책 찾기"
		view.addSubview(bookSearchView)
		view.addSubview(bookCountLabel)
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
		
		bookCountLabel.translatesAutoresizingMaskIntoConstraints = false
		bookCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
		bookCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
		bookCountLabel.topAnchor.constraint(equalTo: bookSearchView.bottomAnchor, constant: 20).isActive = true
		
		booksListTableView.translatesAutoresizingMaskIntoConstraints = false
		booksListTableView.topAnchor.constraint(equalTo: bookCountLabel.bottomAnchor, constant: 15).isActive = true
		booksListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		booksListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		booksListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		booksListTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	// MARK: - Bind Data
	private func bind(to viewModel: BooksListViewModel) {
		viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
		viewModel.totalBooksCount.observe(on: self) { [weak self] _ in self?.updateTotalBooksCount() }
		viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
	}
	
	private func updateItems() {
		booksListTableView.reloadData()
	}
	
	private func updateTotalBooksCount() {
		// 검색된 책 총 수량 표시
		bookCountLabel.text = "검색된 책 수량 : \(viewModel.totalBooksCount.value)"
	}
	
	private func showError(_ error: String) {
		guard !error.isEmpty else { return }
		let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc private func doneButtonTapped(_ textField: UITextField) {
		viewModel.didSearch(searchText: bookSearchTextField.text ?? "")
		self.view.endEditing(true)
	}

}

// MARK: - TextField Delegate
extension BookListViewController: UITextFieldDelegate {
	
	func textFieldNoValueHandler(textField: UITextField) {
		if textField.text?.count == 1 {
			if textField.text?.first == " " {
				textField.text = ""
				return
			}
		}
	}

	@objc private func textFieldEditingChanged(textField: UITextField) {
		textFieldNoValueHandler(textField: textField)
		
		if textField.text == "" {
			bookSearchDoneButton.backgroundColor = .systemGray2
			bookSearchDoneButton.isEnabled = false
		} else {
			bookSearchDoneButton.backgroundColor = .systemBlue
			bookSearchDoneButton.isEnabled = true
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textFieldNoValueHandler(textField: textField)
		
		if textField.text != "" {
			viewModel.didSearch(searchText: bookSearchTextField.text ?? "")
			self.view.endEditing(true)
		} else {
			showError("검색어를 입력해주세요.")
			self.view.endEditing(true)
		}

		return true
	}
}

// MARK: - UITableView Delegate, DataSource
extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.items.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: BooksListItemCell.identifier, for: indexPath) as? BooksListItemCell else { return UITableViewCell() }
		cell.selectionStyle = .none
		
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
