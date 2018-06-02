# AYM_Assignment

This is a tabbed app consists of two screens:
  - Restaurants : Listing top restaurants near the device according to their prominence rating.
  - Weather : Displaying today's weather stats and a detailed forcast for the upcoming five days.

# Tech
This application is following the MVVM architecture and uses reactive techniques to implement it.

### Used pods

  - Core
      - [Moya](https://github.com/Moya/Moya) : Network handling.
      - [RxSwift](https://github.com/ReactiveX/RxSwift) : Core reactive programming 
      - [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa) : UI reactive programming 
  - UI
    - [AlamofireImage](https://github.com/Alamofire/AlamofireImage) : Lazy loading the icons/thumbnails
    - [Cosmos](https://github.com/evgenyneu/Cosmos) : Rating view control

### To do 
  - Fixing the four warnings currently presented in the storyboard.
  - Filtering the weather forcast to display only one forcast per day instead of the hourly forcast currently presented.
  - Displaying a more user friendly error messages.
  - Adding refresh functionality.
  - Allowing the user to change the location manually for a better experience.
