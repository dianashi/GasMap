# GasMap <img src=https://user-images.githubusercontent.com/83667515/189502568-2a1372e8-7f04-41de-815b-e067885d9bcb.jpeg height="40">

iOS app built by [Kevin Jin](https://github.com/kevin21jin) & [Diana Shi](https://github.com/dianashi)


## Overview

GasMap is a mobile iOS app that displays the locations of nearby gas stations. The app shows the closest gas stations to the user's current location and allows users to search gas stations by location.

<img src=https://user-images.githubusercontent.com/83667515/189503116-5e3bf62b-57a1-4cc5-85b3-d507bc204285.jpg width="160"><img src=https://user-images.githubusercontent.com/83667515/189503117-08c569df-7c42-4883-9caa-d0d275c6c7dc.jpg width="160"><img src=https://user-images.githubusercontent.com/83667515/189503118-05e909ad-0a29-441c-bf62-5c09a68cf43e.jpg width="160"><img src=https://user-images.githubusercontent.com/83667515/189503119-7526e196-a479-4c66-ab7a-e2c7ae1f774d.jpg width="160"><img src=https://user-images.githubusercontent.com/83667515/189503120-1aae60f0-fef0-48ae-baa2-d73d6732497e.jpg width="160">

## About the Project

- Technologies used: Swift, Storyboard, GoogleMaps & GooglePlaces APIs
- Design pattern: Model, View, View-Model (MVVM)

## Project Setup

#### Step 1

```
git clone https://github.com/kevin21jin/GasMap.git
```
Clone the repository

#### Step 2

```
cd GasMap
pod install
```
Navigate to the directory and install pods

#### Step 3

Open the file ```./GasMap/Networks/KeyProvider.swift``` and insert your own Google Maps API key
```swift
struct KeyProvider {
    // Enter your API key here
    var googleMapsAPIKey: String = ""
}
```

#### Step 4

Open ```./GasMap.xcworkspace```, build and run the project with Xcode
