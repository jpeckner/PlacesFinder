//
//  FakeSearchRequest+FastCasual.swift
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

let fastCasualResponse: String = """
{
  "region": {
    "center": {
      "latitude": 37.33233141, 
      "longitude": -122.0312186
    }
  }, 
  "total": 53, 
  "businesses": [
    {
      "rating": 3.0, 
      "review_count": 1609, 
      "name": "BJ's Restaurant & Brewhouse", 
      "transactions": [
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/bjs-restaurant-and-brewhouse-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 119.42805897133377, 
      "coordinates": {
        "latitude": 37.331352, 
        "longitude": -122.031773
      }, 
      "alias": "bjs-restaurant-and-brewhouse-cupertino", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/wSmeeXUGGj6lJ8QPSSpXjg/o.jpg", 
      "categories": [
        {
          "alias": "breweries", 
          "title": "Breweries"
        }, 
        {
          "alias": "newamerican", 
          "title": "American (New)"
        }
      ], 
      "display_phone": "(408) 865-6970", 
      "phone": "+14088656970", 
      "id": "qelsX-g8rZ3hHwJ7FeReLg", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "10690 N De Anza Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "10690 N De Anza Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 488, 
      "name": "Outback Steakhouse", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/outback-steakhouse-cupertino-3?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 211.82771427593488, 
      "coordinates": {
        "latitude": 37.33156, 
        "longitude": -122.03318
      }, 
      "alias": "outback-steakhouse-cupertino-3", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/2qKF5C_7l5215b5nJ29k2A/o.jpg", 
      "categories": [
        {
          "alias": "steak", 
          "title": "Steakhouses"
        }
      ], 
      "display_phone": "(408) 255-4400", 
      "phone": "+14082554400", 
      "id": "Ncrnlrjpsu8hrjMKQY3P8Q", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20630 Valley Green Dr", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20630 Valley Green Dr", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 565, 
      "name": "YAYOI", 
      "transactions": [
        "pickup", 
        "delivery", 
        "restaurant_reservation"
      ], 
      "url": "https://www.yelp.com/biz/yayoi-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 690.2859071436673, 
      "coordinates": {
        "latitude": 37.337110507689, 
        "longitude": -122.036201704747
      }, 
      "alias": "yayoi-cupertino", 
      "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/GVivqEV5C1vGaVsYze5Tlw/o.jpg", 
      "categories": [
        {
          "alias": "japanese", 
          "title": "Japanese"
        }, 
        {
          "alias": "comfortfood", 
          "title": "Comfort Food"
        }
      ], 
      "display_phone": "(408) 564-8852", 
      "phone": "+14085648852", 
      "id": "SMVEtOV6PG467oZqyNRhAw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20682 Homestead Rd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "20682 Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 298, 
      "name": "Gamba Karaoke", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/gamba-karaoke-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 891.8230839694538, 
      "coordinates": {
        "latitude": 37.336880983566, 
        "longitude": -122.022911389629
      }, 
      "alias": "gamba-karaoke-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/oYwhOatnQ56U-8BoybCWeg/o.jpg", 
      "categories": [
        {
          "alias": "karaoke", 
          "title": "Karaoke"
        }
      ], 
      "display_phone": "(408) 865-0955", 
      "phone": "+14088650955", 
      "id": "CSWsvjMBCZvsMSVwzK7RQA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19990 E Homestead Rd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "19990 E Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 1836, 
      "name": "Gochi Japanese Fusion Tapas", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/gochi-japanese-fusion-tapas-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$$", 
      "distance": 903.7269452326611, 
      "coordinates": {
        "latitude": 37.3368621985872, 
        "longitude": -122.022732496261
      }, 
      "alias": "gochi-japanese-fusion-tapas-cupertino", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/zm-Fb_VPfOCFzlRuPPYzlA/o.jpg", 
      "categories": [
        {
          "alias": "japanese", 
          "title": "Japanese"
        }, 
        {
          "alias": "tapas", 
          "title": "Tapas Bars"
        }
      ], 
      "display_phone": "(408) 725-0542", 
      "phone": "+14087250542", 
      "id": "d21yLIv0j4Cc2WVNsQAmZw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19980 E Homestead Rd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19980 E Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 307, 
      "name": "What8ver Express", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/what8ver-express-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 906.911547955232, 
      "coordinates": {
        "latitude": 37.324498742943, 
        "longitude": -122.03407823789
      }, 
      "alias": "what8ver-express-cupertino-2", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/-QB7R0RHslW4FvjB5EvR8A/o.jpg", 
      "categories": [
        {
          "alias": "coffee", 
          "title": "Coffee & Tea"
        }, 
        {
          "alias": "taiwanese", 
          "title": "Taiwanese"
        }, 
        {
          "alias": "desserts", 
          "title": "Desserts"
        }
      ], 
      "display_phone": "(408) 873-0918", 
      "phone": "+14088730918", 
      "id": "I7g0uWDP7mYXlCWruZpkyw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "10118 Bandley Dr", 
          "Ste G", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "Ste G", 
        "address3": "", 
        "state": "CA", 
        "address1": "10118 Bandley Dr", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 532, 
      "name": "Homestead Bowl & The X Bar", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/homestead-bowl-and-the-x-bar-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 915.8313988761543, 
      "coordinates": {
        "latitude": 37.33635, 
        "longitude": -122.0406
      }, 
      "alias": "homestead-bowl-and-the-x-bar-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/_2_Je4tKhJ-xqYNWEQxLQQ/o.jpg", 
      "categories": [
        {
          "alias": "bowling", 
          "title": "Bowling"
        }, 
        {
          "alias": "sportsbars", 
          "title": "Sports Bars"
        }, 
        {
          "alias": "tradamerican", 
          "title": "American (Traditional)"
        }
      ], 
      "display_phone": "(408) 255-5700", 
      "phone": "+14082555700", 
      "id": "MIEhBEAZXiXzJZfuoqAgtA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20990 Homestead Rd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20990 Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 291, 
      "name": "Local Cafe", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/local-cafe-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 936.949793982017, 
      "coordinates": {
        "latitude": 37.33685, 
        "longitude": -122.04032
      }, 
      "alias": "local-cafe-cupertino-2", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/SZFO5x9eO70GGwZTMu5qvQ/o.jpg", 
      "categories": [
        {
          "alias": "chinese", 
          "title": "Chinese"
        }, 
        {
          "alias": "hkcafe", 
          "title": "Hong Kong Style Cafe"
        }
      ], 
      "display_phone": "(408) 865-1122", 
      "phone": "+14088651122", 
      "id": "adj2wRQcDAfiloVmhOylNA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20956 W Homestead Rd", 
          "Ste H", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "Ste H", 
        "address3": "", 
        "state": "CA", 
        "address1": "20956 W Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 252, 
      "name": "Taiwan Porridge Kingdom", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/taiwan-porridge-kingdom-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 937.8939442468978, 
      "coordinates": {
        "latitude": 37.3365845444208, 
        "longitude": -122.040379456096
      }, 
      "alias": "taiwan-porridge-kingdom-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/IYUur5s4ZES_sgOGOwnbDQ/o.jpg", 
      "categories": [
        {
          "alias": "taiwanese", 
          "title": "Taiwanese"
        }, 
        {
          "alias": "chinese", 
          "title": "Chinese"
        }
      ], 
      "display_phone": "(408) 253-2569", 
      "phone": "+14082532569", 
      "id": "k69A174QtWGhBIs3ApUMVw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20956 Homestead Rd", 
          "Ste A1", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "Ste A1", 
        "address3": "", 
        "state": "CA", 
        "address1": "20956 Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 468, 
      "name": "Shanghai Garden", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/shanghai-garden-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 958.8901657459836, 
      "coordinates": {
        "latitude": 37.3369525401659, 
        "longitude": -122.040375618897
      }, 
      "alias": "shanghai-garden-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/QBcZES-xl38gMiAF_2OLmQ/o.jpg", 
      "categories": [
        {
          "alias": "chinese", 
          "title": "Chinese"
        }, 
        {
          "alias": "seafood", 
          "title": "Seafood"
        }
      ], 
      "display_phone": "(408) 517-9812", 
      "phone": "+14085179812", 
      "id": "rchTioIUSAZs1NW_86yVZw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20956 Homestead Rd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20956 Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 586, 
      "name": "Tea Era", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/tea-era-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 969.1534041048661, 
      "coordinates": {
        "latitude": 37.3371504153713, 
        "longitude": -122.04035249287
      }, 
      "alias": "tea-era-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/s3Nrq6dYmt_uQoUVGN55lg/o.jpg", 
      "categories": [
        {
          "alias": "coffee", 
          "title": "Coffee & Tea"
        }, 
        {
          "alias": "bubbletea", 
          "title": "Bubble Tea"
        }, 
        {
          "alias": "taiwanese", 
          "title": "Taiwanese"
        }
      ], 
      "display_phone": "(408) 996-9898", 
      "phone": "+14089969898", 
      "id": "Q0s4evO-h2RHNGRr5QFBAA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20916 Homestead Rd", 
          "Ste F", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "Ste F", 
        "address3": "", 
        "state": "CA", 
        "address1": "20916 Homestead Rd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 291, 
      "name": "Lee's Sandwiches", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/lees-sandwiches-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 984.558532836051, 
      "coordinates": {
        "latitude": 37.323542551526, 
        "longitude": -122.02986670876
      }, 
      "alias": "lees-sandwiches-cupertino-2", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/Y3uMcVgSs_m2MOZtSA_FHg/o.jpg", 
      "categories": [
        {
          "alias": "sandwiches", 
          "title": "Sandwiches"
        }, 
        {
          "alias": "vietnamese", 
          "title": "Vietnamese"
        }, 
        {
          "alias": "juicebars", 
          "title": "Juice Bars & Smoothies"
        }
      ], 
      "display_phone": "(408) 446-5030", 
      "phone": "+14084465030", 
      "id": "EunYm0tJuO70HyV6d4nJYw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20363 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "20363 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 250, 
      "name": "Cafe Torre", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/cafe-torre-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 990.0374141100508, 
      "coordinates": {
        "latitude": 37.32324, 
        "longitude": -122.02952
      }, 
      "alias": "cafe-torre-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/ybm5HFw92vzbD8hueWWGMA/o.jpg", 
      "categories": [
        {
          "alias": "italian", 
          "title": "Italian"
        }, 
        {
          "alias": "mediterranean", 
          "title": "Mediterranean"
        }, 
        {
          "alias": "wine_bars", 
          "title": "Wine Bars"
        }
      ], 
      "display_phone": "(408) 257-2383", 
      "phone": "+14082572383", 
      "id": "U11kl0_E9yV0KvUdYGecrQ", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20343 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20343 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.5, 
      "review_count": 745, 
      "name": "Happy Lemon", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/happy-lemon-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1098.2414161019358, 
      "coordinates": {
        "latitude": 37.32258, 
        "longitude": -122.03121
      }, 
      "alias": "happy-lemon-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/N2BrStlU4oFk_a5-6s2xIg/o.jpg", 
      "categories": [
        {
          "alias": "bubbletea", 
          "title": "Bubble Tea"
        }, 
        {
          "alias": "juicebars", 
          "title": "Juice Bars & Smoothies"
        }
      ], 
      "display_phone": "(408) 216-0232", 
      "phone": "+14082160232", 
      "id": "Y8cb0323lHRxUFWtrVWYRg", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20488 Stevens Creek Blvd", 
          "Ste 2040", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "Ste 2040", 
        "address3": "", 
        "state": "CA", 
        "address1": "20488 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 331, 
      "name": "Boudin SF", 
      "transactions": [
        "pickup", 
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/boudin-sf-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1124.7716197522107, 
      "coordinates": {
        "latitude": 37.3225571921616, 
        "longitude": -122.03449420053
      }, 
      "alias": "boudin-sf-cupertino-2", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/E5qv3pD2BcSWciSJ3xF4bQ/o.jpg", 
      "categories": [
        {
          "alias": "bakeries", 
          "title": "Bakeries"
        }, 
        {
          "alias": "salad", 
          "title": "Salad"
        }, 
        {
          "alias": "sandwiches", 
          "title": "Sandwiches"
        }
      ], 
      "display_phone": "(408) 638-8006", 
      "phone": "+14086388006", 
      "id": "KVJOLq4gl0eOm3cdPkMbbA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20682 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20682 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.5, 
      "review_count": 870, 
      "name": "Philz Coffee-  Cupertino", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/philz-coffee-cupertino-cupertino-5?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1137.4485681970193, 
      "coordinates": {
        "latitude": 37.3224764649389, 
        "longitude": -122.034667027534
      }, 
      "alias": "philz-coffee-cupertino-cupertino-5", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/Nuy5AjMNoD3r6hasmCofbg/o.jpg", 
      "categories": [
        {
          "alias": "coffee", 
          "title": "Coffee & Tea"
        }
      ], 
      "display_phone": "(408) 446-9000", 
      "phone": "+14084469000", 
      "id": "R4ISdv8FUCkSwucO8sZSIw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20686 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20686 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 433, 
      "name": "Panera Bread", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/panera-bread-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1182.7229277439515, 
      "coordinates": {
        "latitude": 37.3232765197754, 
        "longitude": -122.038063049316
      }, 
      "alias": "panera-bread-cupertino", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/rQPRebmdjKIjsUoZVREKEw/o.jpg", 
      "categories": [
        {
          "alias": "sandwiches", 
          "title": "Sandwiches"
        }, 
        {
          "alias": "salad", 
          "title": "Salad"
        }, 
        {
          "alias": "soup", 
          "title": "Soup"
        }
      ], 
      "display_phone": "(408) 996-9131", 
      "phone": "+14089969131", 
      "id": "L4BLVP--fz-tou2oaC0yIg", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20807 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20807 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 198, 
      "name": "Nick the Greek", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/nick-the-greek-sunnyvale-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1201.174119326062, 
      "coordinates": {
        "latitude": 37.3378467, 
        "longitude": -122.0429006
      }, 
      "alias": "nick-the-greek-sunnyvale-2", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/9jspfYoCs9arVPuOA18ZdQ/o.jpg", 
      "categories": [
        {
          "alias": "greek", 
          "title": "Greek"
        }
      ], 
      "display_phone": "(408) 685-2830", 
      "phone": "+14086852830", 
      "id": "PvTeayYupbe_YxXy8XDqDg", 
      "is_closed": false, 
      "location": {
        "city": "Sunnyvale", 
        "display_address": [
          "1687 Hollenbeck Ave", 
          "Ste A", 
          "Sunnyvale, CA 94087"
        ], 
        "country": "US", 
        "address2": "Ste A", 
        "address3": "", 
        "state": "CA", 
        "address1": "1687 Hollenbeck Ave", 
        "zip_code": "94087"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 104, 
      "name": "House of Bagels", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/house-of-bagels-sunnyvale?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1202.374611964785, 
      "coordinates": {
        "latitude": 37.3378442801289, 
        "longitude": -122.042918193085
      }, 
      "alias": "house-of-bagels-sunnyvale", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/6Alj_qMWgiHpgwVwvhd25w/o.jpg", 
      "categories": [
        {
          "alias": "bakeries", 
          "title": "Bakeries"
        }, 
        {
          "alias": "bagels", 
          "title": "Bagels"
        }
      ], 
      "display_phone": "(408) 245-0311", 
      "phone": "+14082450311", 
      "id": "CuKWQq_YLHGCYjc60_PyTA", 
      "is_closed": false, 
      "location": {
        "city": "Sunnyvale", 
        "display_address": [
          "1681 Hollenbeck Ave", 
          "Sunnyvale, CA 94087"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "1681 Hollenbeck Ave", 
        "zip_code": "94087"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 304, 
      "name": "Shan", 
      "transactions": [
        "pickup", 
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/shan-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1207.4489777226993, 
      "coordinates": {
        "latitude": 37.3236, 
        "longitude": -122.02364
      }, 
      "alias": "shan-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/iiv0q2y5dHNuHOvs3JwIgA/o.jpg", 
      "categories": [
        {
          "alias": "indpak", 
          "title": "Indian"
        }, 
        {
          "alias": "pakistani", 
          "title": "Pakistani"
        }, 
        {
          "alias": "halal", 
          "title": "Halal"
        }
      ], 
      "display_phone": "(408) 260-9200", 
      "phone": "+14082609200", 
      "id": "vP4G_apXTOiV8kDnpQK_HA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20007 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "20007 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 936, 
      "name": "Whole Foods Market", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/whole-foods-market-cupertino-3?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$$", 
      "distance": 1220.335961672923, 
      "coordinates": {
        "latitude": 37.3236052, 
        "longitude": -122.0395887
      }, 
      "alias": "whole-foods-market-cupertino-3", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/gy5o-z0I182hIFTSZsWzMg/o.jpg", 
      "categories": [
        {
          "alias": "grocery", 
          "title": "Grocery"
        }, 
        {
          "alias": "healthmarkets", 
          "title": "Health Markets"
        }, 
        {
          "alias": "organic_stores", 
          "title": "Organic Stores"
        }
      ], 
      "display_phone": "(408) 257-7000", 
      "phone": "+14082577000", 
      "id": "znqgHjMX96zxXM2yciwNyw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20955 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20955 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 448, 
      "name": "The Counter Cupertino", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/the-counter-cupertino-cupertino-4?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1251.861162123808, 
      "coordinates": {
        "latitude": 37.322615, 
        "longitude": -122.024067
      }, 
      "alias": "the-counter-cupertino-cupertino-4", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/bA6za1QZa850FSUM9JaDog/o.jpg", 
      "categories": [
        {
          "alias": "burgers", 
          "title": "Burgers"
        }
      ], 
      "display_phone": "(408) 477-2917", 
      "phone": "+14084772917", 
      "id": "SU9pz5lhUhLsBA59nF-fMA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20080 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20080 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 134, 
      "name": "Pokeholics", 
      "transactions": [
        "pickup", 
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/pokeholics-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1265.008623390126, 
      "coordinates": {
        "latitude": 37.3231349, 
        "longitude": -122.021364
      }, 
      "alias": "pokeholics-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/Hl8DqDOUT2mcYa77lUPbMQ/o.jpg", 
      "categories": [
        {
          "alias": "poke", 
          "title": "Poke"
        }, 
        {
          "alias": "bubbletea", 
          "title": "Bubble Tea"
        }, 
        {
          "alias": "coffee", 
          "title": "Coffee & Tea"
        }
      ], 
      "display_phone": "(650) 556-3876", 
      "phone": "+16505563876", 
      "id": "2ivDhdUcmb6wZtfwsCvlAQ", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19929 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "19929 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 181, 
      "name": "Noodle+ Mongolian BBQ", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/noodle-mongolian-bbq-sunnyvale-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1267.1682461025162, 
      "coordinates": {
        "latitude": 37.339286, 
        "longitude": -122.042546
      }, 
      "alias": "noodle-mongolian-bbq-sunnyvale-2", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/N6B0QkE6KSs_gu083N2zkQ/o.jpg", 
      "categories": [
        {
          "alias": "buffets", 
          "title": "Buffets"
        }, 
        {
          "alias": "chinese", 
          "title": "Chinese"
        }
      ], 
      "display_phone": "(669) 246-5060", 
      "phone": "+16692465060", 
      "id": "BrHEEaU98sMQbUTLi6kWbQ", 
      "is_closed": false, 
      "location": {
        "city": "Sunnyvale", 
        "display_address": [
          "1653 Hollenbeck Ave", 
          "Sunnyvale, CA 94087"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": null, 
        "state": "CA", 
        "address1": "1653 Hollenbeck Ave", 
        "zip_code": "94087"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 511, 
      "name": "Fontana's Italian", 
      "transactions": [
        "restaurant_reservation"
      ], 
      "url": "https://www.yelp.com/biz/fontanas-italian-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1287.3743035797627, 
      "coordinates": {
        "latitude": 37.322473442578, 
        "longitude": -122.038853871592
      }, 
      "alias": "fontanas-italian-cupertino", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/-u1TQDIrPEc6NRIbdqgNZA/o.jpg", 
      "categories": [
        {
          "alias": "italian", 
          "title": "Italian"
        }, 
        {
          "alias": "seafood", 
          "title": "Seafood"
        }
      ], 
      "display_phone": "(408) 725-0188", 
      "phone": "+14087250188", 
      "id": "NhCTUXXhwQeFb_I06sHAfQ", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20840 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "20840 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 907, 
      "name": "Arya Global Cuisine", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/arya-global-cuisine-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1354.4415150964628, 
      "coordinates": {
        "latitude": 37.322467, 
        "longitude": -122.022232
      }, 
      "alias": "arya-global-cuisine-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/Siyd0dJIDV1ciqpvFfAiFg/o.jpg", 
      "categories": [
        {
          "alias": "mideastern", 
          "title": "Middle Eastern"
        }, 
        {
          "alias": "venues", 
          "title": "Venues & Event Spaces"
        }, 
        {
          "alias": "persian", 
          "title": "Persian/Iranian"
        }
      ], 
      "display_phone": "(408) 996-9606", 
      "phone": "+14089969606", 
      "id": "Dq4TExGNy2x5kOsTJk781Q", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19930 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19930 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 2.5, 
      "review_count": 131, 
      "name": "Panda Express", 
      "transactions": [
        "pickup", 
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/panda-express-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1402.7930024879822, 
      "coordinates": {
        "latitude": 37.3225583357164, 
        "longitude": -122.041250939361
      }, 
      "alias": "panda-express-cupertino-2", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/5rvEXpW-l5sQjMFlIamsng/o.jpg", 
      "categories": [
        {
          "alias": "chinese", 
          "title": "Chinese"
        }, 
        {
          "alias": "hotdogs", 
          "title": "Fast Food"
        }
      ], 
      "display_phone": "(408) 517-0670", 
      "phone": "+14085170670", 
      "id": "bgPBDK_2vpYOkNMUvZf1Jg", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "21000 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "21000 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 216, 
      "name": "Yoshinoya - Cupertino", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/yoshinoya-cupertino-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1416.0590714373618, 
      "coordinates": {
        "latitude": 37.32328, 
        "longitude": -122.01979
      }, 
      "alias": "yoshinoya-cupertino-cupertino-2", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/0OEu8lcemgIljkma3ViZEQ/o.jpg", 
      "categories": [
        {
          "alias": "japanese", 
          "title": "Japanese"
        }
      ], 
      "display_phone": "(408) 253-8049", 
      "phone": "+14082538049", 
      "id": "-zWFXtyba-NA3NX5q3ZiIw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19825 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19825 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 184, 
      "name": "Crab Lover", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/crab-lover-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1508.392181609754, 
      "coordinates": {
        "latitude": 37.3194412, 
        "longitude": -122.0325249
      }, 
      "alias": "crab-lover-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/jaZb6ZJ485VtgpNePIjccA/o.jpg", 
      "categories": [
        {
          "alias": "cajun", 
          "title": "Cajun/Creole"
        }, 
        {
          "alias": "seafood", 
          "title": "Seafood"
        }
      ], 
      "display_phone": "(408) 899-6562", 
      "phone": "+14088996562", 
      "id": "3JSS9bo3FQ1UH6nc2D6q8g", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "10275 S Deanza Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "10275 S Deanza Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 372, 
      "name": "Azuma Japanese Cuisine", 
      "transactions": [
        "pickup", 
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/azuma-japanese-cuisine-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1528.8959826064781, 
      "coordinates": {
        "latitude": 37.3238662871101, 
        "longitude": -122.017592751976
      }, 
      "alias": "azuma-japanese-cuisine-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/IbjnHKHVavhkewZkAv5WPw/o.jpg", 
      "categories": [
        {
          "alias": "japanese", 
          "title": "Japanese"
        }
      ], 
      "display_phone": "(408) 257-4057", 
      "phone": "+14082574057", 
      "id": "nTSkcDYvc3YisO3FqdBCnA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19645 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19645 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 922, 
      "name": "Liang's Village Cupertino", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/liangs-village-cupertino-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1532.959008038138, 
      "coordinates": {
        "latitude": 37.322294, 
        "longitude": -122.019334
      }, 
      "alias": "liangs-village-cupertino-cupertino", 
      "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/T18wTAbqCrS6CRma0gI31w/o.jpg", 
      "categories": [
        {
          "alias": "taiwanese", 
          "title": "Taiwanese"
        }, 
        {
          "alias": "chinese", 
          "title": "Chinese"
        }, 
        {
          "alias": "noodles", 
          "title": "Noodles"
        }
      ], 
      "display_phone": "(408) 725-9999", 
      "phone": "+14087259999", 
      "id": "-U8xaVqbWTeu-EFvD5rZ8A", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19772 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19772 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 921, 
      "name": "Bitter+Sweet", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/bitter-sweet-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1575.5826301229304, 
      "coordinates": {
        "latitude": 37.3181638185566, 
        "longitude": -122.03151641898
      }, 
      "alias": "bitter-sweet-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/4iYl7F2rdhAJeEgQj8jMIA/o.jpg", 
      "categories": [
        {
          "alias": "desserts", 
          "title": "Desserts"
        }, 
        {
          "alias": "coffee", 
          "title": "Coffee & Tea"
        }
      ], 
      "display_phone": "(408) 255-2600", 
      "phone": "+14082552600", 
      "id": "4hc7siWI1hG_orZ2cChpHg", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "20560 Town Center Ln", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "20560 Town Center Ln", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 699, 
      "name": "Harumi Sushi", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/harumi-sushi-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1589.9283772822698, 
      "coordinates": {
        "latitude": 37.3218092, 
        "longitude": -122.0190434
      }, 
      "alias": "harumi-sushi-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/y_3bpRlJsoQbtoM8eY5CaA/o.jpg", 
      "categories": [
        {
          "alias": "japanese", 
          "title": "Japanese"
        }, 
        {
          "alias": "sushi", 
          "title": "Sushi Bars"
        }
      ], 
      "display_phone": "(408) 973-9985", 
      "phone": "+14089739985", 
      "id": "OBEh8kb1ERfEiUzZ6cdPVA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19754 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19754 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 1256, 
      "name": "Curry House", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/curry-house-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1596.3982986008043, 
      "coordinates": {
        "latitude": 37.317982688713, 
        "longitude": -122.031823084656
      }, 
      "alias": "curry-house-cupertino-2", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/ncwcQmBw1Lx4t5s4vSFMgQ/o.jpg", 
      "categories": [
        {
          "alias": "japanese", 
          "title": "Japanese"
        }, 
        {
          "alias": "seafood", 
          "title": "Seafood"
        }
      ], 
      "display_phone": "(408) 517-1440", 
      "phone": "+14085171440", 
      "id": "a9NjWj3G0et9ELYw-o97vw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "10350 S De Anza Blvd", 
          "Cupertino, CA 95015"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "10350 S De Anza Blvd", 
        "zip_code": "95015"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 851, 
      "name": "Kong Tofu & BBQ Korean Cuisine", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/kong-tofu-and-bbq-korean-cuisine-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1619.7458627004712, 
      "coordinates": {
        "latitude": 37.32253, 
        "longitude": -122.017667
      }, 
      "alias": "kong-tofu-and-bbq-korean-cuisine-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/v9EPV2YYo9NFgDHepxaqFg/o.jpg", 
      "categories": [
        {
          "alias": "korean", 
          "title": "Korean"
        }, 
        {
          "alias": "bbq", 
          "title": "Barbeque"
        }
      ], 
      "display_phone": "(408) 863-0234", 
      "phone": "+14088630234", 
      "id": "yq2_x-8jNy__WJ1xLkqBZw", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19626 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": null, 
        "state": "CA", 
        "address1": "19626 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 1134, 
      "name": "Yogurtland", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/yogurtland-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1664.1291683039233, 
      "coordinates": {
        "latitude": 37.3217943235963, 
        "longitude": -122.01785359045
      }, 
      "alias": "yogurtland-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/huZbo9KAgLgj7B5C4PMdkA/o.jpg", 
      "categories": [
        {
          "alias": "icecream", 
          "title": "Ice Cream & Frozen Yogurt"
        }, 
        {
          "alias": "desserts", 
          "title": "Desserts"
        }
      ], 
      "display_phone": "(408) 996-1776", 
      "phone": "+14089961776", 
      "id": "OGxo4yHmWgX9RM3v0JVqWA", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19700 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19700 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 1397, 
      "name": "Gyu-Kaku Japanese BBQ", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/gyu-kaku-japanese-bbq-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1674.3308904564567, 
      "coordinates": {
        "latitude": 37.3225649361151, 
        "longitude": -122.01680590311
      }, 
      "alias": "gyu-kaku-japanese-bbq-cupertino", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/Zc8Qy_XuDy2xE7Lmps8ipw/o.jpg", 
      "categories": [
        {
          "alias": "japanese", 
          "title": "Japanese"
        }, 
        {
          "alias": "bbq", 
          "title": "Barbeque"
        }, 
        {
          "alias": "asianfusion", 
          "title": "Asian Fusion"
        }
      ], 
      "display_phone": "(408) 865-0149", 
      "phone": "+14088650149", 
      "id": "Q0r7HaGy3z7CoUJUGEHKYQ", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19620 Stevens Creek Blvd", 
          "Ste 150", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "Ste 150", 
        "address3": "", 
        "state": "CA", 
        "address1": "19620 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 391, 
      "name": "Chipotle Mexican Grill", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/chipotle-mexican-grill-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1677.9496008158574, 
      "coordinates": {
        "latitude": 37.31701, 
        "longitude": -122.03275
      }, 
      "alias": "chipotle-mexican-grill-cupertino", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/nTuZxV5cZfJyJkbsRoSXjg/o.jpg", 
      "categories": [
        {
          "alias": "mexican", 
          "title": "Mexican"
        }, 
        {
          "alias": "hotdogs", 
          "title": "Fast Food"
        }
      ], 
      "display_phone": "(408) 252-5421", 
      "phone": "+14082525421", 
      "id": "JPzPfi4GW9ISPtUGY2Ms7Q", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "10385 S De Anza Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "10385 S De Anza Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 3.0, 
      "review_count": 416, 
      "name": "Olarn Thai Cuisine", 
      "transactions": [
        "pickup"
      ], 
      "url": "https://www.yelp.com/biz/olarn-thai-cuisine-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 1690.1322003540454, 
      "coordinates": {
        "latitude": 37.3221664428711, 
        "longitude": -122.01789855957
      }, 
      "alias": "olarn-thai-cuisine-cupertino", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/C_LBTxN0iPnP9XO0qDwnJQ/o.jpg", 
      "categories": [
        {
          "alias": "thai", 
          "title": "Thai"
        }
      ], 
      "display_phone": "(408) 255-2170", 
      "phone": "+14082552170", 
      "id": "bFdxvD2QavIMyxCeoAw2nQ", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "19672 Stevens Creek Blvd", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "19672 Stevens Creek Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 554, 
      "name": "Rio Adobe Southwest Cafe", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/rio-adobe-southwest-cafe-cupertino-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 1909.951830467753, 
      "coordinates": {
        "latitude": 37.31528, 
        "longitude": -122.03274
      }, 
      "alias": "rio-adobe-southwest-cafe-cupertino-2", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/_7js9SSHuSFTPzIsxjbkxQ/o.jpg", 
      "categories": [
        {
          "alias": "mexican", 
          "title": "Mexican"
        }, 
        {
          "alias": "catering", 
          "title": "Caterers"
        }
      ], 
      "display_phone": "(408) 873-1600", 
      "phone": "+14088731600", 
      "id": "MNWHOW70M7qcYHreUwJlHQ", 
      "is_closed": false, 
      "location": {
        "city": "Cupertino", 
        "display_address": [
          "10525 S De Anza Blvd", 
          "Ste 100", 
          "Cupertino, CA 95014"
        ], 
        "country": "US", 
        "address2": "Ste 100", 
        "address3": "", 
        "state": "CA", 
        "address1": "10525 S De Anza Blvd", 
        "zip_code": "95014"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 137, 
      "name": "Gold Rush Eatery", 
      "transactions": [
        "pickup", 
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/gold-rush-eatery-sunnyvale-6?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 3143.2221310198265, 
      "coordinates": {
        "latitude": 37.3551306948281, 
        "longitude": -122.010198819353
      }, 
      "alias": "gold-rush-eatery-sunnyvale-6", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/CFpX50jiQRajc_tx_GVShA/o.jpg", 
      "categories": [
        {
          "alias": "foodtrucks", 
          "title": "Food Trucks"
        }, 
        {
          "alias": "burgers", 
          "title": "Burgers"
        }, 
        {
          "alias": "beerbar", 
          "title": "Beer Bar"
        }
      ], 
      "display_phone": "(408) 743-5336", 
      "phone": "+14087435336", 
      "id": "rRVAOEHSBuvzOWkz6NJ72A", 
      "is_closed": false, 
      "location": {
        "city": "Sunnyvale", 
        "display_address": [
          "1010 S Wolfe Rd", 
          "Sunnyvale, CA 94036"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "1010 S Wolfe Rd", 
        "zip_code": "94036"
      }
    }, 
    {
      "rating": 4.5, 
      "review_count": 169, 
      "name": "Eat On Monday", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/eat-on-monday-mountain-view-3?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 7195.697985398587, 
      "coordinates": {
        "latitude": 37.3931694030762, 
        "longitude": -122.085517883301
      }, 
      "alias": "eat-on-monday-mountain-view-3", 
      "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/7CEeSxJjlRCYjU9hs2MKLA/o.jpg", 
      "categories": [
        {
          "alias": "foodtrucks", 
          "title": "Food Trucks"
        }, 
        {
          "alias": "catering", 
          "title": "Caterers"
        }
      ], 
      "display_phone": "(408) 658-8366", 
      "phone": "+14086588366", 
      "id": "M4u2h2lfTIXUUWV3xZzVKA", 
      "is_closed": false, 
      "location": {
        "city": "Mountain View", 
        "display_address": [
          "Mountain View, CA 94041"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "", 
        "zip_code": "94041"
      }
    }, 
    {
      "rating": 4.5, 
      "review_count": 92, 
      "name": "Tasteebytes SJ", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/tasteebytes-sj-san-jose?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 12090.834483102259, 
      "coordinates": {
        "latitude": 37.36058, 
        "longitude": -121.89913
      }, 
      "alias": "tasteebytes-sj-san-jose", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/nxVvWa0ydNA-XfWpWEwd6w/o.jpg", 
      "categories": [
        {
          "alias": "foodtrucks", 
          "title": "Food Trucks"
        }, 
        {
          "alias": "hotdog", 
          "title": "Hot Dogs"
        }
      ], 
      "display_phone": "(669) 243-7123", 
      "phone": "+16692437123", 
      "id": "jWWg0p9GTCho2RJIPhD6pQ", 
      "is_closed": false, 
      "location": {
        "city": "San Jose", 
        "display_address": [
          "326 Commercial St", 
          "San Jose, CA 95132"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "326 Commercial St", 
        "zip_code": "95132"
      }
    }, 
    {
      "rating": 4.5, 
      "review_count": 239, 
      "name": "Agha's Gyro Express", 
      "transactions": [
        "pickup", 
        "delivery"
      ], 
      "url": "https://www.yelp.com/biz/aghas-gyro-express-san-jose?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$", 
      "distance": 12877.88096470711, 
      "coordinates": {
        "latitude": 37.33178, 
        "longitude": -121.88543
      }, 
      "alias": "aghas-gyro-express-san-jose", 
      "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/5UqmNt1CynAyWLFGhMbiYg/o.jpg", 
      "categories": [
        {
          "alias": "foodtrucks", 
          "title": "Food Trucks"
        }, 
        {
          "alias": "halal", 
          "title": "Halal"
        }, 
        {
          "alias": "greek", 
          "title": "Greek"
        }
      ], 
      "display_phone": "(408) 603-0792", 
      "phone": "+14086030792", 
      "id": "c6IRi5NnLrST81a3csZN5Q", 
      "is_closed": false, 
      "location": {
        "city": "San Jose", 
        "display_address": [
          "300 S 2nd St", 
          "San Jose, CA 95113"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "300 S 2nd St", 
        "zip_code": "95113"
      }
    }, 
    {
      "rating": 5.0, 
      "review_count": 75, 
      "name": "Magic Dante - Entertainer", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/magic-dante-entertainer-san-jose-2?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "distance": 13274.362372713787, 
      "coordinates": {
        "latitude": 37.29223, 
        "longitude": -121.88128
      }, 
      "alias": "magic-dante-entertainer-san-jose-2", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/Ue2FEM2b4QFS56eZ6ZNzJA/o.jpg", 
      "categories": [
        {
          "alias": "magicians", 
          "title": "Magicians"
        }
      ], 
      "display_phone": "(415) 735-5321", 
      "phone": "+14157355321", 
      "id": "lFcYm_8i87pnNrmMKAZgow", 
      "is_closed": false, 
      "location": {
        "city": "San Jose", 
        "display_address": [
          "San Jose, CA 95125"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": null, 
        "zip_code": "95125"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 184, 
      "name": "EAT Club", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/eat-club-redwood-city-3?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "distance": 15451.247964273507, 
      "coordinates": {
        "latitude": 37.4845, 
        "longitude": -122.22772
      }, 
      "alias": "eat-club-redwood-city-3", 
      "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/AifJwi3kEiMqlhken-XDxg/o.jpg", 
      "categories": [
        {
          "alias": "catering", 
          "title": "Caterers"
        }
      ], 
      "display_phone": "(800) 316-6440", 
      "phone": "+18003166440", 
      "id": "LwO-wJUvvm1o_hzWlcwWVw", 
      "is_closed": false, 
      "location": {
        "city": "Redwood City", 
        "display_address": [
          "Redwood City, CA 94303"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": null, 
        "zip_code": "94303"
      }
    }, 
    {
      "rating": 4.0, 
      "review_count": 118, 
      "name": "Whisk on Wheels", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/whisk-on-wheels-redwood-city?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "price": "$$", 
      "distance": 24539.026906274976, 
      "coordinates": {
        "latitude": 37.48853, 
        "longitude": -122.22662
      }, 
      "alias": "whisk-on-wheels-redwood-city", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/qt-YlMlVl6G5a2wXxHgtJA/o.jpg", 
      "categories": [
        {
          "alias": "catering", 
          "title": "Caterers"
        }, 
        {
          "alias": "foodtrucks", 
          "title": "Food Trucks"
        }, 
        {
          "alias": "tradamerican", 
          "title": "American (Traditional)"
        }
      ], 
      "display_phone": "(415) 902-1188", 
      "phone": "+14159021188", 
      "id": "X1NgPMMREoTTDAZPe6D-kA", 
      "is_closed": false, 
      "location": {
        "city": "Redwood City", 
        "display_address": [
          "Redwood City, CA 94063"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "", 
        "zip_code": "94063"
      }
    }, 
    {
      "rating": 4.5, 
      "review_count": 127, 
      "name": "Black Tie Transportation", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/black-tie-transportation-pleasanton?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "distance": 41718.5569164269, 
      "coordinates": {
        "latitude": 37.6969217, 
        "longitude": -121.9196087
      }, 
      "alias": "black-tie-transportation-pleasanton", 
      "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/HtskMJjRE3uYDW19hxFr8A/o.jpg", 
      "categories": [
        {
          "alias": "limos", 
          "title": "Limos"
        }, 
        {
          "alias": "tours", 
          "title": "Tours"
        }, 
        {
          "alias": "towncarservice", 
          "title": "Town Car Service"
        }
      ], 
      "display_phone": "(855) 506-4330", 
      "phone": "+18555064330", 
      "id": "IEblZU6s_PC41Q11QGNMAQ", 
      "is_closed": false, 
      "location": {
        "city": "Pleasanton", 
        "display_address": [
          "7080 Commerce Dr", 
          "Pleasanton, CA 94588"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "7080 Commerce Dr", 
        "zip_code": "94588"
      }
    }, 
    {
      "rating": 3.5, 
      "review_count": 14, 
      "name": "Matson", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/matson-oakland?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "distance": 56656.90572779816, 
      "coordinates": {
        "latitude": 37.803689, 
        "longitude": -122.275341
      }, 
      "alias": "matson-oakland", 
      "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/m9hUnlJvuk88Zi_7EMhR9A/o.jpg", 
      "categories": [
        {
          "alias": "shipping_centers", 
          "title": "Shipping Centers"
        }, 
        {
          "alias": "transport", 
          "title": "Transportation"
        }
      ], 
      "display_phone": "(800) 462-8766", 
      "phone": "+18004628766", 
      "id": "E5S2HvoxV7f_Bx3-aWtz7g", 
      "is_closed": false, 
      "location": {
        "city": "Oakland", 
        "display_address": [
          "555 12th St", 
          "Oakland, CA 94607"
        ], 
        "country": "US", 
        "address2": null, 
        "address3": "", 
        "state": "CA", 
        "address1": "555 12th St", 
        "zip_code": "94607"
      }
    }, 
    {
      "rating": 2.5, 
      "review_count": 1483, 
      "name": "Uber", 
      "transactions": [], 
      "url": "https://www.yelp.com/biz/uber-san-francisco?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw", 
      "distance": 59926.86801079394, 
      "coordinates": {
        "latitude": 37.7755318297526, 
        "longitude": -122.418006526796
      }, 
      "alias": "uber-san-francisco", 
      "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/oH0eM2cZasHaNZ3PwkkU7A/o.jpg", 
      "categories": [
        {
          "alias": "taxis", 
          "title": "Taxis"
        }
      ], 
      "display_phone": "", 
      "phone": "", 
      "id": "Cc62hS5gEkXpvLJtm6GU-A", 
      "is_closed": false, 
      "location": {
        "city": "San Francisco", 
        "display_address": [
          "San Francisco, CA 94103"
        ], 
        "country": "US", 
        "address2": "", 
        "address3": "", 
        "state": "CA", 
        "address1": "", 
        "zip_code": "94103"
      }
    }
  ]
}
"""
