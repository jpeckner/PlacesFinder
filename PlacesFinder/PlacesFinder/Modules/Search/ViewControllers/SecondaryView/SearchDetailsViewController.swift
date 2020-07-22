//
//  SearchDetailsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

import SwiftUI

typealias SearchDetailsViewController = UIHostingController<SearchDetailsViewSUI>

struct SearchDetailsViewSUI: View {

    @ObservedObject private var viewModel: ValueObservable<SearchDetailsViewModel>
    @ObservedObject private var colorings: ValueObservable<SearchDetailsViewColorings>

    init(viewModel: SearchDetailsViewModel,
         colorings: SearchDetailsViewColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    var body: some View {
        VStack {
            ForEach(viewModel.value.sections.indices) { sectionIdx in
                self.sectionView(self.viewModel.value.sections[sectionIdx])
            }
        }
    }

    private func sectionView(_ section: SearchDetailsViewModel.Section) -> some View {
        switch section {
        case let .info(rows):
            return ForEach(rows.indices) { rowIdx in
                self.infoSectionRowView(rows[rowIdx])
            }
        case let .location(rows):
            return ForEach(rows.indices) { rowIdx in
                self.mapSectionRowView(rows[rowIdx])
            }
        }
    }

    private func infoSectionRowView(_ row: SearchDetailsInfoSectionViewModel) -> AnyView {
        switch row {
        case let .basicInfo(viewModel):
            return AnyView(
                BasicInfoCell(viewModel: viewModel,
                              colorings: colorings.value)
            )
        case let .phoneNumber(viewModel):
            return AnyView(
                Text(viewModel.phoneLabelText)
            )
        }
    }

    private func mapSectionRowView(_ row: SearchDetailsMapSectionViewModel) -> AnyView {
        switch row {
        case let .mapCoordinate(viewModel):
            return AnyView(
                Text("\(viewModel.coordinate.latitude) - \(viewModel.coordinate.longitude)")
            )
        }
    }

}

extension SearchDetailsViewSUI {

    func configure(_ viewModel: SearchDetailsViewModel,
                   colorings: SearchDetailsViewColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}

private struct BasicInfoCell: View {

    let viewModel: SearchDetailsBasicInfoViewModel
    let colorings: SearchDetailsViewColorings

    var body: some View {
        VStack {
            DownloadedImageViewSUI(viewModel: viewModel.image)

            StyledText(text: viewModel.name.value,
                       styleClass: .subtitle,
                       textColoring: colorings.bodyTextColoring)

            viewModel.address.map {
                StyledText(text: $0.value,
                           styleClass: .body,
                           textColoring: colorings.bodyTextColoring)
            }
        }
    }

}

#if DEBUG

struct SearchDetailsViewSUI_Previews: PreviewProvider {

    static var previews: some View {
        SearchDetailsViewSUI(colorings: AppColorings.defaultColorings.searchProgress)
            .previewDisplayName("iPhone SE")
    }

    private static var stubViewModel: SearchDetailsViewModel {
        SearchDetailsViewModel(
            placeName: "My Favorite Restaurant",
            sections: [
                .info([
                    .basicInfo(SearchDetailsBasicInfoViewModel(
                        image: DownloadedImageViewModel(url: URL(string: "https://picsum.photos/200")!),
                        name: try! NonEmptyString("My Favorite Restaurant"),
                        address: try! NonEmptyString("1234 Main St\nSome Town, CA 91234"),
                        ratingsAverage: .four,
                        numRatingsMessage: "999 reviews",
                        pricing: "$$$$$",
                        apiLinkCallback: nil
                    ))
                ]),
                .location([
                    .mapCoordinate(SearchDetailsMapCoordinateViewModel(
                        placeName: try! NonEmptyString("My Favorite Restaurant"),
                        address: <#T##NonEmptyString?#>,
                        coordinate: <#T##PlaceLookupCoordinate#>,
                        regionRadius: <#T##PlaceLookupDistance#>
                    ))
                ])
            ],
            store: StubDispatchingStore(),
            removeDetailedEntityAction: StubAction.genericAction
        )
    }

}

#endif

//class SearchDetailsViewController: SingleContentViewController {
//
//    private var viewModel: SearchDetailsViewModel
//    private var colorings: SearchDetailsViewColorings
//    private let tableView: UITableView
//    private let titleLabel: StyledLabel
//
//    init(viewModel: SearchDetailsViewModel,
//         appSkin: AppSkin) {
//        self.viewModel = viewModel
//        self.colorings = appSkin.colorings.searchDetails
//        self.tableView = UITableView()
//        self.titleLabel = StyledLabel(numberOfLines: 1)
//
//        super.init(contentView: tableView,
//                   viewColoring: colorings.viewColoring)
//
//        setupTitleView()
//        setupTableView()
//        configure(viewModel,
//                  appSkin: appSkin)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupTitleView() {
//        titleLabel.adjustFontSizeToFitWidth()
//        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
//        navigationItem.titleView = titleLabel
//    }
//
//    private func setupTableView() {
//        tableView.performStandardSetup(
//            cellTypes: allDetailsSectionTypes.flatMap { $0.allCellTypes },
//            dataSource: self,
//            delegate: self
//        )
//    }
//
//}
//
//extension SearchDetailsViewController {
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        tableView.scrollToTop(animated: false)
//    }
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        tableView.scrollToTop(animated: false)
//    }
//
//}
//
//extension SearchDetailsViewController {
//
//    func configure(_ viewModel: SearchDetailsViewModel,
//                   appSkin: AppSkin) {
//        self.colorings = appSkin.colorings.searchDetails
//        self.viewModel = viewModel
//
//        viewColoring = colorings.viewColoring
//
//        titleLabel.configure(.navBarTitle,
//                             textColoring: appSkin.colorings.navBar.titleTextColoring)
//        titleLabel.text = viewModel.placeName
//        titleLabel.sizeToFit()
//
//        UIView.animate(
//            withDuration: 0,
//            animations: {
//                self.tableView.reloadData()
//            }, completion: { _ in
//                self.tableView.scrollToTop(animated: true)
//            }
//        )
//    }
//
//}
//
//extension SearchDetailsViewController: PopCallbackViewController {
//
//    func viewControllerWasPopped() {
//        viewModel.dispatchRemoveDetailsAction()
//    }
//
//}
//
//extension SearchDetailsViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.sectionsCount
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.cellViewModels(sectionIndex: section).count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellViewModel = viewModel.cellViewModel(sectionIndex: indexPath.section,
//                                                    rowIndex: indexPath.row)
//        let cell = tableView.dequeueReusableCell(withCellType: cellViewModel.cellType, for: indexPath)
//
//        AssertionHandler.assertIfErrorThrown {
//            try cellViewModel.configureCell(cell,
//                                            colorings: colorings)
//        }
//
//        cell.selectionStyle = cellViewModel.isSelectable ? .default : .none
//        cell.makeTransparent()
//
//        return cell
//    }
//
//}
//
//extension SearchDetailsViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        let cellViewModel = viewModel.cellViewModel(sectionIndex: indexPath.section,
//                                                    rowIndex: indexPath.row)
//        return cellViewModel.isSelectable ? indexPath : nil
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        switch tableView.cellForRow(at: indexPath) {
//        case let phoneCell as SearchDetailsPhoneNumberCell:
//            phoneCell.executeTapCallback()
//        default:
//            break
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.tableView(tableView, heightForHeaderInSection: section) > 0 ? UIView() : nil
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch viewModel.section(sectionIndex: section) {
//        case .info,
//             .location:
//            return 0.0
//        }
//    }
//
//}
