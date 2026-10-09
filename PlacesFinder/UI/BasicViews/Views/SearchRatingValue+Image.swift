//
//  SearchRatingValue+Image.swift
//  PlacesFinder
//
//  Copyright (c) 2020 Justin Peckner
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

import UIKit

extension SearchRatingValue {

    var starsImage: UIImage {
        switch self {
        case .one:
            return Asset.extraLarge1.image
        case .oneAndAHalf:
            return Asset.extraLarge1Half.image
        case .two:
            return Asset.extraLarge2.image
        case .twoAndAHalf:
            return Asset.extraLarge2Half.image
        case .three:
            return Asset.extraLarge3.image
        case .threeAndAHalf:
            return Asset.extraLarge3Half.image
        case .four:
            return Asset.extraLarge4.image
        case .fourAndAHalf:
            return Asset.extraLarge4Half.image
        case .five:
            return Asset.extraLarge5.image
        }
    }

}
