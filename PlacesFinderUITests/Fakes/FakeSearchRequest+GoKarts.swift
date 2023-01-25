//
//  FakeSearchRequest+GoKarts.swift
//  PlacesFinderUITests
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

let goKartsResponse: String = """
{
  "region": {
    "center": {
      "latitude": 37.33233141,
      "longitude": -122.0312186
    }
  },
  "total": 6,
  "businesses": [
    {
      "rating": 2.5,
      "review_count": 587,
      "name": "K1 Speed",
      "transactions": [],
      "url": "https://www.yelp.com/biz/k1-speed-santa-clara?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw",
      "distance": 6277.4233064857035,
      "coordinates": {
        "latitude": 37.3721782092911,
        "longitude": -121.980909806438
      },
      "alias": "k1-speed-santa-clara",
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/IkT9as1lBsvNcNqEqi-Scw/o.jpg",
      "categories": [
        {
          "alias": "amusementparks",
          "title": "Amusement Parks"
        },
        {
          "alias": "gokarts",
          "title": "Go Karts"
        },
        {
          "alias": "venues",
          "title": "Venues & Event Spaces"
        }
      ],
      "display_phone": "(408) 338-0579",
      "phone": "+14083380579",
      "id": "LMiYwSqd0k4nFT_EqsRi7g",
      "is_closed": false,
      "location": {
        "city": "Santa Clara",
        "display_address": [
          "2925 Mead Ave",
          "Santa Clara, CA 95051"
        ],
        "country": "US",
        "address2": "",
        "address3": "",
        "state": "CA",
        "address1": "2925 Mead Ave",
        "zip_code": "95051"
      }
    },
    {
      "rating": 5.0,
      "review_count": 8,
      "name": "SSi Racing Team",
      "transactions": [],
      "url": "https://www.yelp.com/biz/ssi-racing-team-san-jose?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw",
      "distance": 12952.67960919907,
      "coordinates": {
        "latitude": 37.39999,
        "longitude": -121.92672
      },
      "alias": "ssi-racing-team-san-jose",
      "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/Md0MUX9klkM2rC25YHPRbA/o.jpg",
      "categories": [
        {
          "alias": "driving_schools",
          "title": "Driving Schools"
        },
        {
          "alias": "gokarts",
          "title": "Go Karts"
        }
      ],
      "display_phone": "(408) 786-6979",
      "phone": "+14087866979",
      "id": "khssGT_dl8ijL63MnTce1g",
      "is_closed": false,
      "location": {
        "city": "San Jose",
        "display_address": [
          "San Jose, CA 95134"
        ],
        "country": "US",
        "address2": "",
        "address3": "",
        "state": "CA",
        "address1": "",
        "zip_code": "95134"
      }
    },
    {
      "rating": 4.0,
      "review_count": 391,
      "name": "LeMans Karting",
      "transactions": [],
      "url": "https://www.yelp.com/biz/lemans-karting-fremont?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw",
      "distance": 20201.949011753175,
      "coordinates": {
        "latitude": 37.49543,
        "longitude": -121.93055
      },
      "alias": "lemans-karting-fremont",
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/dhm-PibkpQSFGkKgZL0ELA/o.jpg",
      "categories": [
        {
          "alias": "gokarts",
          "title": "Go Karts"
        },
        {
          "alias": "venues",
          "title": "Venues & Event Spaces"
        },
        {
          "alias": "racetracks",
          "title": "Race Tracks"
        }
      ],
      "display_phone": "(510) 770-9001",
      "phone": "+15107709001",
      "id": "2QdkGzjSkrKJFewCU6VEJg",
      "is_closed": false,
      "location": {
        "city": "Fremont",
        "display_address": [
          "45957 Hotchkiss St",
          "Fremont, CA 94539"
        ],
        "country": "US",
        "address2": "",
        "address3": "",
        "state": "CA",
        "address1": "45957 Hotchkiss St",
        "zip_code": "94539"
      }
    },
    {
      "rating": 3.5,
      "review_count": 564,
      "name": "Sky High Sports - Santa Clara",
      "transactions": [],
      "url": "https://www.yelp.com/biz/sky-high-sports-santa-clara-santa-clara?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw",
      "distance": 6320.498963020213,
      "coordinates": {
        "latitude": 37.371582,
        "longitude": -121.97927
      },
      "alias": "sky-high-sports-santa-clara-santa-clara",
      "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/3t3VV5-z7DcOmskmlHFeAA/o.jpg",
      "categories": [
        {
          "alias": "eventplanning",
          "title": "Party & Event Planning"
        },
        {
          "alias": "trampoline",
          "title": "Trampoline Parks"
        }
      ],
      "display_phone": "(408) 496-5867",
      "phone": "+14084965867",
      "id": "VHU1pOyYgsxGybdybo2ctw",
      "is_closed": false,
      "location": {
        "city": "Santa Clara",
        "display_address": [
          "2880 Mead Ave",
          "Santa Clara, CA 95051"
        ],
        "country": "US",
        "address2": null,
        "address3": "",
        "state": "CA",
        "address1": "2880 Mead Ave",
        "zip_code": "95051"
      }
    },
    {
      "rating": 3.0,
      "review_count": 1386,
      "name": "California's Great America",
      "transactions": [],
      "url": "https://www.yelp.com/biz/californias-great-america-santa-clara?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw",
      "distance": 8768.585743552032,
      "coordinates": {
        "latitude": 37.395613,
        "longitude": -121.972017
      },
      "alias": "californias-great-america-santa-clara",
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/ANRpmmyIhC9SO8OvmmOGhw/o.jpg",
      "categories": [
        {
          "alias": "amusementparks",
          "title": "Amusement Parks"
        },
        {
          "alias": "waterparks",
          "title": "Water Parks"
        }
      ],
      "display_phone": "(408) 988-1776",
      "phone": "+14089881776",
      "id": "UPhaHh4CE4E_grqyI_S9Pw",
      "is_closed": false,
      "location": {
        "city": "Santa Clara",
        "display_address": [
          "4701 Great America Pkwy",
          "Santa Clara, CA 95054"
        ],
        "country": "US",
        "address2": "",
        "address3": "",
        "state": "CA",
        "address1": "4701 Great America Pkwy",
        "zip_code": "95054"
      }
    },
    {
      "rating": 4.5,
      "review_count": 45,
      "name": "Balloon Twisting - Kat's Clever Creations",
      "transactions": [],
      "url": "https://www.yelp.com/biz/balloon-twisting-kats-clever-creations-fremont?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw",
      "distance": 26162.459308160855,
      "coordinates": {
        "latitude": 37.56749,
        "longitude": -122.0404
      },
      "alias": "balloon-twisting-kats-clever-creations-fremont",
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/Sc0oEBFiwjHQlF28_1u9Rg/o.jpg",
      "categories": [
        {
          "alias": "eventplanning",
          "title": "Party & Event Planning"
        }
      ],
      "display_phone": "(415) 562-4421",
      "phone": "+14155624421",
      "id": "PRdzWuEJbSrU2jurhTi5rg",
      "is_closed": false,
      "location": {
        "city": "Fremont",
        "display_address": [
          "4534 Pecos Ct",
          "Fremont, CA 94555"
        ],
        "country": "US",
        "address2": "",
        "address3": "",
        "state": "CA",
        "address1": "4534 Pecos Ct",
        "zip_code": "94555"
      }
    }
  ]
}
"""
