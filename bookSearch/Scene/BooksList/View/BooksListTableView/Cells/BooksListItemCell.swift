//
//  BooksListItemCell.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import UIKit

class BooksListItemCell: UITableViewCell {
	static let identifier = "BooksListItemCell"
	
	private lazy var booksListView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray
//		view.addSubview(bookSearchTextField)
//		view.addSubview(bookSearchDoneButton)
		return view
	}()

    override func awakeFromNib() {
        super.awakeFromNib()
		configure()
		setupAutoLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	private func configure() {
		contentView.backgroundColor = .lightGray
		contentView.addSubview(booksListView)
	}
	
		// 오토레이아웃
	private func setupAutoLayout() {
		
		booksListView.translatesAutoresizingMaskIntoConstraints = false
		booksListView.heightAnchor.constraint(equalToConstant: 48).isActive = true
		booksListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
		booksListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
		booksListView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
	}
}
