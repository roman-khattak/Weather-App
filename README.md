# Weather API Implementation

This is a Flutter project that fetches weather data from an external API and displays it in a user-friendly interface. The app provides weather forecasts for the next five days.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Architecture](#architecture)
- [State Management](#state-management)
- [Libraries](#libraries)
- [Contributing](#contributing)

## Features

- Weather data retrieval from an external API (openweathermap.org).
- Displaying weather forecasts for the next five days.
- User-friendly interface with a search bar for entering the city name.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- [Flutter](https://flutter.dev/) installed on your local machine.
- A code editor or IDE of your choice (e.g., Visual Studio Code, Android Studio).

### Installation

1. Clone this repository:

   git clone https://github.com/roman-khattak/weather-api-implementation.git

2. Navigate to the project directory:

   cd weather-api-implementation

3. Install project dependencies:

   flutter pub get

4. Run the app:

   flutter run

### Architecture
The project follows a simple architecture with the following components:

WeatherApiService: Responsible for fetching weather data from the OpenWeatherMap API. It processes the API response and packages it into structured WeatherData objects.

WeatherData: Represents weather data for a specific date, including information such as date, description, temperature, and an icon URL.

WeatherForecastController (State Management): Manages the application's state using GetX state management. It handles data fetching, error handling, and manages two lists: currentDayWeatherData and otherDaysWeatherData, which store the weather data for the current day and other days, respectively.

WeatherForecastScreen: The user interface for the application. It provides a search bar for entering the city name and displays weather data in a user-friendly format. It uses GetX for state management to update the UI based on data changes.

### State Management
This project uses the GetX library for state management. GetX is a lightweight and high-performance library that simplifies state management and reactive programming in Flutter.

### Libraries
The project uses the following main libraries:

http: Used for making HTTP requests to fetch weather data from the API.

GetX: Provides state management, dependency injection, and route management.

Google Fonts: Used to load Google Fonts for custom text styling.

Intl: To manage the DateTime.

### Contributing
Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

Fork the repository.
Create a new branch for your feature or bug fix: git checkout -b feature/your-feature-name.
Commit your changes.
Push your branch: git push origin feature/your-feature-name.
Create a pull request to the main branch of this repository.
Please ensure that your code follows the existing coding standards and conventions.



A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
