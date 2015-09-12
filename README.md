# Vélib' iOS

iOS application demonstrating the use of the bikeshare systems (especially Paris
Vélib') usage prediction webservice I developed during my internship at
[Applidium](http://applidium.com).

The application uses [Realm](https://realm.io) for data persistency and
map is displayed using [Mapbox](https://www.mapbox.com).

## Purpose

The purpose of this repository is mainly to help understanding both Realm
and Mapbox iOS SDKs, as well as basic Objective-C code.

If you really want to run the application and get predictions, see the next
section.

Some of instance variables are in snake_case, because the Webservice returns
snake_cased JSON, this can be improved using
[Realm+JSON](http://cocoapods.org/pods/Realm+JSON) pod.

## Prediction API

The application needs to fetch data from an instance of the
[bike-share-prediction](https://github.com/applidium/bike-share-prediction) webservice
in order to run properly.

An example instance is running [here](http://bike-share-prediction-example.herokuapp.com) on Heroku,
but does not actually predict Vélib' usage, it only contains Vélib' stations
that can be drawn on the map, with their informations (name, address, number of
bik stands) to be displayed on the detail view.

The application can run as is, but if you want predictions, you will have to
get your own instance of the prediction webservice up and running.

Once the instance is set up, update the `FRVWebserviceURL` defined in
`Velib/Classes/Velib.h` to the base URL to access your webservice.
