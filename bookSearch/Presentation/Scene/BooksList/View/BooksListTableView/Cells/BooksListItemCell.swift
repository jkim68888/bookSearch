//
//  BooksListItemCell.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import UIKit

class BooksListItemCell: UITableViewCell {
	static let identifier = "BooksListItemCell"
	
	private lazy var bookView: UIView = {
		let view = UIView()
		view.addSubview(bookTextView)
		view.addSubview(bookImage)
		return view
	}()
	
	private lazy var bookTextView: UIView = {
		let view = UIView()
		view.addSubview(bookTitle)
		view.addSubview(bookAuthors)
		view.addSubview(bookPublishedDate)
		return view
	}()
	
	private var bookTitle: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		return lbl
	}()
	
	private var bookAuthors: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		return lbl
	}()
	
	private var bookPublishedDate: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		lbl.textColor = .systemGray
		return lbl
	}()
	
	private var bookImage: UIImageView = {
		let img = UIImageView()
		img.backgroundColor = .blue
		return img
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
		setupAutoLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	private func configure() {
		contentView.addSubview(bookView)
	}
	
	// 오토레이아웃
	private func setupAutoLayout() {
		bookView.translatesAutoresizingMaskIntoConstraints = false
		bookView.heightAnchor.constraint(equalToConstant: 120).isActive = true
		bookView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
		bookView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
		bookView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		bookView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		
		bookTextView.translatesAutoresizingMaskIntoConstraints = false
		bookTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
		bookTextView.leadingAnchor.constraint(equalTo: bookView.leadingAnchor).isActive = true
		bookTextView.trailingAnchor.constraint(equalTo: bookImage.leadingAnchor, constant: -20).isActive = true
		bookTextView.centerYAnchor.constraint(equalTo: bookView.centerYAnchor).isActive = true

		bookImage.translatesAutoresizingMaskIntoConstraints = false
		bookImage.widthAnchor.constraint(equalToConstant: 61).isActive = true
		bookImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
		bookImage.trailingAnchor.constraint(equalTo: bookView.trailingAnchor).isActive = true
		bookImage.centerYAnchor.constraint(equalTo: bookView.centerYAnchor).isActive = true

		bookTitle.translatesAutoresizingMaskIntoConstraints = false
		bookTitle.leadingAnchor.constraint(equalTo: bookTextView.leadingAnchor).isActive = true
		bookTitle.trailingAnchor.constraint(equalTo: bookTextView.trailingAnchor).isActive = true
		bookTitle.topAnchor.constraint(equalTo: bookTextView.topAnchor).isActive = true

		bookAuthors.translatesAutoresizingMaskIntoConstraints = false
		bookAuthors.leadingAnchor.constraint(equalTo: bookTextView.leadingAnchor).isActive = true
		bookAuthors.trailingAnchor.constraint(equalTo: bookTextView.trailingAnchor).isActive = true
		bookAuthors.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 5).isActive = true

		bookPublishedDate.translatesAutoresizingMaskIntoConstraints = false
		bookPublishedDate.leadingAnchor.constraint(equalTo: bookTextView.leadingAnchor).isActive = true
		bookPublishedDate.trailingAnchor.constraint(equalTo: bookTextView.trailingAnchor).isActive = true
		bookPublishedDate.topAnchor.constraint(equalTo: bookAuthors.bottomAnchor, constant: 5).isActive = true
	}
	
	// MARK: - Bind Data
	func binding(with viewModel: BookListItemViewModel) {
		self.bookTitle.text = "제목: \(viewModel.title)"
		self.bookAuthors.text = "저자: \(viewModel.authors.joined(separator: ","))"
		self.bookPublishedDate.text = "출판일: \(viewModel.publishedDate)"
		
		if let smallThumbnail = viewModel.smallThumbnail {
			self.bookImage.load(url: smallThumbnail)
		}
	}
}
