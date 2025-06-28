This is a simple Find My country app built using the REST COUNTRIES Open API. The app displays User’s default country based on the current location of the user and a list of cached countries based on user search and selection, shows detailed information about selected Country, and allows users to Search for countries, also user can swipe to refresh when got online again. The challenge was implemented using Swift and SwiftUI, supporting iOS versions 18 and above.

Features:

Country Home View:
* A search icon at the top allows the user to search for Countries by name.
* Add country button at the bottom allows the user to search and select Countries to add to other countries list.
* Displays User’s default country based on the current location of the user:
    * Country flag.
    * Country name.
    * Country currency and its symbol.
    * Automatically adds the first country to the main view based on the user's current location (via GPS).
    * If the user denies location permission, Egypt country is added instead.

* Displays selected countries in other countries section:
    * Country flag
    * Country name
* When user click the search icon, the app shows the search sheet with all countries by default.
* When the user enters a search term, it shows results using the search mechanism locally and can navigate to country details when click on it.
* When the user click Add country button it opens select country sheet with search, then user can select more than one country to add it to other counties list and cache it for offline mode.
* user can only add up to 5 countries to counties list or he will be notified via toast message.
* user can remove from counties list via confirmation dialog.
* also user can swipe to refresh when got online again.

Country Details View
* Displays detailed information for the selected Country:
    * Flag
    * country name
    * country capital
    * country currency
    * country currency symbol
    * country languages

Architecture MVVM (Model-View-ViewModel) with Router Pattern.
The app is built using the MVVM (Model-View-ViewModel) architecture, which allows for better separation of concerns and easier testing:
* Model: Represents the data structure, such as Country model.
* View: The UI layer that interacts with the user (e.g., HomeScreen, CountryDetailsScreen).
* ViewModel: Handles the business logic, prepares the data for the view, and communicates with the use case layer and other managers.
* Combine is Apple’s native framework for building reactive, composable, and asynchronous applications across iOS and other Apple platforms. It simplifies managing complex data flows, UI updates, and error handling by reducing boilerplate code. Combine is particularly effective in large-scale applications where traditional patterns fall short in handling dynamic or asynchronous behavior. When used properly, Combine can significantly enhance code maintainability, readability, and testability.

Router Pattern is used to manage the navigation flow of the app. The Router is responsible for:
* Navigating between different screens (e.g., from the HomeScreen to the CountryDetailsScreen) via AppDestinationUIPilot.

Use Cases & Repository
* Use Cases handle specific business logic and interact with the repository to fetch data.
* Repository: Acts as the intermediary between the Use Cases and the Remote Data Source. It fetches the data and ensures it's available to the ViewModel.

Remote Data Source & Networking Layer
* RemoteDataSource handles the actual network calls to the provided APIs using a custom API Networking Layer.
* The API networking layer is responsible for constructing the requests, handling the responses, and providing the results to the repository.
Provided APIs
* A: Get Popular Movies (https://restcountries.com/v2/all)

Technologies:
* Swift 5.0+
* iOS 18
* SwiftUI
* Networking: URLSession
* Local Storage: UserDefault
* Testing: Unit Tests
* PackageManager (SDWebImageSwiftUI)

Design & Layout
* Reusable components to maintain consistency throughout the app.
* View components are chosen for simplicity and performance. The design focus is functional and clear.
* The app does not focus on design aesthetics but prioritizes clean, functional layout and API integration.
* Saves fetched country data locally using UserDefault.
* Allows users to access the app even without an internet connection with alerts.
* Displays an error message and empty views if the API call fails.
* User can swipe to refresh when got online again

 Unit Testing
* Includes unit tests for:
    * Network layer
    * Repository
    * UseCase
    * ViewModel
