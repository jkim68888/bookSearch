//
//  AppDIContainer.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/06.
//

import Foundation

final class AppDIContainer {
	
	lazy var appConfiguration = AppConfiguration()
	
	// MARK: - Network
	lazy var apiDataTransferService: DataTransferService = {
		let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
										  queryParameters: ["key": appConfiguration.apiKey])
		
		let apiDataNetwork = DefaultNetworkService(config: config)
		return DefaultDataTransferService(with: apiDataNetwork)
	}()
	
		// MARK: - DIContainers of scenes
	func makeBooksListSceneDIContainer() -> BooksSceneDIContainer {
		let dependencies = BooksSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
		return BooksSceneDIContainer(dependencies: dependencies)
	}
}
