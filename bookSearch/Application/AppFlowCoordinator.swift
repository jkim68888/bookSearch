//
//  AppFlowCoordinator.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/06.
//

import UIKit

final class AppFlowCoordinator {
	var navigationController: UINavigationController
	private let appDIContainer: AppDIContainer
	
	init(navigationController: UINavigationController,
		 appDIContainer: AppDIContainer) {
		self.navigationController = navigationController
		self.appDIContainer = appDIContainer
	}
	
	func start() {
		let booksSceneDIContainer = appDIContainer.makeBooksListSceneDIContainer()
		let flow = booksSceneDIContainer.makeBookListFlowCoordinator(navigationController: navigationController)
		flow.start()
	}
}
