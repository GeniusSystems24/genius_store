# Genius Store - Library Directory Structure

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This document provides an overview of the Genius Store application architecture, structure, and components. The application follows **Clean Architecture** with **MVVM (Model-View-ViewModel)** pattern to achieve separation of concerns, testability, and maintainability.

## 🏗️ Architecture Overview

The project implements Clean Architecture with three main layers:

1. **Presentation Layer** (`lib/presentation/`): Contains all UI components including screens, common widgets, and state management using Riverpod.

2. **Domain Layer** (`lib/domain/`): Houses the business logic, entities, repository interfaces, and use cases that define the core functionality.

3. **Data Layer** (`lib/data/`): Implements the repository interfaces and provides concrete data sources (local storage, Firebase, etc.).

4. **Core Module** (`lib/core/`): Contains shared utilities, constants, configurations, and services used across the application.

## 🔄 Data Flow

The data flows through the application in the following manner:

1. **UI Layer** (Presentation) - Displays data and captures user inputs
2. **ViewModels/Providers** (Presentation) - Manages UI state and communicates with use cases
3. **Use Cases** (Domain) - Executes business logic by orchestrating entities and repositories
4. **Repository Interfaces** (Domain) - Defines data operations contracts
5. **Repository Implementations** (Data) - Implements repositories by coordinating data sources
6. **Data Sources** (Data) - Handles raw data operations with external systems (Firebase, local storage)

## 📱 State Management

The application uses **Riverpod** for state management, which provides:

- Dependency injection
- Reactive state management
- Scoped providers
- Seamless integration with async operations

## 🧩 Design Patterns

The application implements several design patterns to improve code quality:

1. **Repository Pattern**: Abstracts data sources behind a common interface, making the application independent of data source implementations.

2. **Factory Pattern**: Used for creating objects without specifying the exact class of object that will be created.

3. **Dependency Injection**: Implemented via Riverpod to provide dependencies to classes rather than having them create their own.

4. **Observer Pattern**: Used for reactive programming through Riverpod's state notifiers.

5. **Adapter Pattern**: Used in data sources to convert between different data representations.

6. **Builder Pattern**: Used for complex object construction, especially for UI components.

7. **Strategy Pattern**: Used for implementing different algorithms or behaviors that can be selected at runtime.

## 📂 Directory Structure

```text
lib/
├── app.dart                # Main application configuration
├── main.dart               # Entry point of the application
├── core/                   # Core components shared across the app
├── data/                   # Data layer implementation
├── domain/                 # Domain layer with business logic
└── presentation/           # Presentation layer with UI components
```

Each directory has its own README.md file with more detailed information about its contents and purpose.
