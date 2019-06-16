//
//  SearchDetailsMapCell.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import MapKit
import Shared
import UIKit

class SearchDetailsMapCell: UITableViewCell {

    private let mapView: MKMapView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.mapView = MKMapView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
        setupMapView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(mapView)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(contentView)
            make.height.equalTo(mapView.snp.width).priority(999)
        }
    }

    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.delegate = self
    }

}

extension SearchDetailsMapCell {

    func configure(_ viewModel: SearchDetailsMapCoordinateViewModel) {
        guard !(mapView.annotations.contains { $0.title == viewModel.placeName.value }) else { return }
        mapView.removeAnnotations(mapView.annotations)

        mapView.centerOnLocation(viewModel.coordinate.clCoordinate,
                                 regionRadius: CLLocationDistance(viewModel.regionRadius.converted(to: .meters).value))
        mapView.annotateLocation(viewModel.coordinate.clCoordinate,
                                 title: viewModel.placeName,
                                 subtitle: viewModel.address)
    }

}

extension SearchDetailsMapCell: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let userCLLocation = userLocation.coordinate.clLocation
        let userDistanceFromCenter = mapView.centerCoordinate.clLocation.distance(from: userCLLocation)

        // Add 10% extra radius to prevent the user's location from being right on the edge of the map
        mapView.centerOnLocation(mapView.centerCoordinate,
                                 regionRadius: userDistanceFromCenter * 1.1)

        // Ignore future updates
        mapView.delegate = nil
    }

}
