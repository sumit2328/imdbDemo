
# IMDB Demo

This project demonstrates an IMDB-like app that fetches movie details and handles them using a combination of MVVM architecture and Core Data for persistence.

## Features

- Fetch movie list and details from the OMDB API
- Save  movies from Core Data
- Validate search input
- Unit tests for validation, API requests, and Core Data operations

## Components

### APIManager

Handles API requests and responses. It uses `NetworkHandler` to perform network requests and `ResponseHandler` to parse the responses.

### NetworkHandler

Executes the network requests and handles the data received from the server.

### ResponseHandler

Parses the network response into the required model or handles errors if any occur.

### MovieManager

Manages Core Data operations for saving, deleting, and fetching movies.

### SearchValidator

Validates the search text to ensure it is not empty or nil.

## Unit Tests

- `SearchValidationTestCases`: Tests the `SearchValidator` for valid and invalid search texts.
- `MovieViewModelTests`: Tests the `MovieViewModel` for successful and failed API requests.
- `MovieManagerTests`: Tests the `MovieManager` for saving, deleting, and fetching movies using an in-memory Core Data stack.
- `MockAPIManager`: Mocks the API manager for testing purposes.

## How to Run

1. Clone the repository.
2. Open the project in Xcode.
3. Run the project on the simulator or a device.
4. Run the unit tests by pressing `Cmd+U`.

## Dependencies

- Xcode 12.5+
- Swift 5.3+

## API Key

Replace the `apikey` in `ProductEndPoint` with your own API key from [OMDB API](http://www.omdbapi.com/).
