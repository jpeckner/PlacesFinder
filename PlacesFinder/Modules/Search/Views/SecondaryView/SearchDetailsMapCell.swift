//
//  SearchDetailsMapCell.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
