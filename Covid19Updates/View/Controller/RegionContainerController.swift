//
//  RegionContainerController.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import UIKit

class RegionContainerController: UIViewController {
    
	var regionController: RegionController!
	var isUpdating: Bool = false {
		didSet {
			updateTime()
		}
	}

	var isSearching: Bool = false {
		didSet {
			view.transition(duration: 0.25) {
				self.labelTitle.isHidden = self.isSearching
				self.labelUpdated.isHidden = self.isSearching
				self.buttonSearch.isHidden = self.isSearching
				self.searchBar.isHidden = !self.isSearching
				self.regionController.view.isHidden = self.isSearching

				if self.isSearching {
					self.searchBar.text = ""
					self.searchBar.becomeFirstResponder()
					MapController.instance.showRegionScreen()
				} else {
					self.searchBar.resignFirstResponder()
				}
			}
		}
	}

	@IBOutlet var effectViewBackground: UIVisualEffectView!
	@IBOutlet var effectViewHeader: UIVisualEffectView!
	@IBOutlet var labelTitle: UILabel!
	@IBOutlet var labelUpdated: UILabel!
	@IBOutlet var buttonSearch: UIButton!
	@IBOutlet var searchBar: UISearchBar!

	override func viewDidLoad() {
		super.viewDidLoad()

		if #available(iOS 13.0, *) {
			effectViewBackground.effect = UIBlurEffect(style: .systemMaterial)
			effectViewBackground.contentView.alpha = 0

			effectViewHeader.effect = UIBlurEffect(style: .systemMaterial)
		}

		if #available(iOS 11.0, *) {
			labelTitle.font = .preferredFont(forTextStyle: .largeTitle)
		} else {
			/// iOS 10
			labelTitle.font = .boldSystemFont(ofSize: 24)
		}

		Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
			self.updateTime()
		}

//		regionListController.tableView.superview?.isHidden = true
//		regionListController.tableView.delegate = self
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is RegionController {
			regionController = segue.destination as? RegionController
		}
	}

	func update(report: Report?) {
		UIView.transition(with: view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
			self.labelTitle.text = report?.region.name ?? "No data"
		}, completion: nil)

		updateTime()
	}

	func updateTime() {
		if isUpdating {
			self.labelUpdated.text = "Updating..."
			return
		}

		self.labelUpdated.text = self.regionController.report?.lastUpdate.relativeTimeString
	}

	@IBAction func buttonSearchTapped(_ sender: Any) {
		isSearching = true
	}
}

extension RegionContainerController: UISearchBarDelegate, UITableViewDelegate {
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		isSearching = false
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		var reports = DataManager.instance.allReports

		let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		if !query.isEmpty {
			reports = reports.filter({ report in
				report.region.name.lowercased().contains(query)
			})
		}

		
	}
}
