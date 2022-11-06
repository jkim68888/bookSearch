//
//  BookDetailViewController.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/06.
//

import UIKit

class BookDetailViewController: UIViewController {
	// MARK: - ViewModel
	private var viewModel: BookDetailViewModel!
	
	// MARK: - UI
	private lazy var scrollView : UIScrollView = {
		let sv = UIScrollView()
		sv.addSubview(contentView)
		return sv
	}()
	
	private lazy var contentView : UIView = {
		let view = UIView()
		view.addSubview(bookImage)
		view.addSubview(bookTitle)
		view.addSubview(bookDescriptions)
		return view
	}()
	
	private lazy var bookImage: UIImageView = {
		let view = UIImageView()
		return view
	}()
	
	private var bookTitle: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		lbl.textAlignment = .center
		return lbl
	}()
	
	private var bookDescriptions: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		lbl.numberOfLines = 0
		return lbl
	}()
	
	static func create(with viewModel: BookDetailViewModel) -> BookDetailViewController {
		let view = BookDetailViewController()
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
    }
    
	private func configure() {
		view.backgroundColor = .white
		view.addSubview(scrollView)
		
		let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
		contentViewHeight.priority = .defaultLow
		contentViewHeight.isActive = true
	}
	
	// 오토레이아웃
	private func setupAutoLayout() {
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
		contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
		
		bookImage.translatesAutoresizingMaskIntoConstraints = false
		bookImage.widthAnchor.constraint(equalToConstant: 128).isActive = true
		bookImage.heightAnchor.constraint(equalToConstant: 196).isActive = true
		bookImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
		bookImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
		
		bookTitle.translatesAutoresizingMaskIntoConstraints = false
		bookTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
		bookTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
		bookTitle.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 20).isActive = true
		bookTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
		
		bookDescriptions.translatesAutoresizingMaskIntoConstraints = false
		bookDescriptions.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
		bookDescriptions.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
		bookDescriptions.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 10).isActive = true
		bookDescriptions.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
		bookDescriptions.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
	}
	
	// MARK: - Bind Data
	private func bind(to viewModel: BookDetailViewModel) {
		viewModel.book.observe(on: self) { [weak self] book in
			guard let thumbnail = viewModel.book.value?.thumbnail else { return }
			
			self?.bookImage.load(url: thumbnail)
			self?.bookTitle.text = viewModel.title
			self?.bookDescriptions.text = viewModel.book.value?.description
		}
	}
}
