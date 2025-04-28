# Screens

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains all the screens of the Genius Store application, organized by feature. Each screen implements a distinct view that users interact with.

## Purpose

The screens directory:

- Organizes UI screens by feature/domain
- Implements the visual layout of each application view
- Handles screen-specific user interactions
- Connects UI components with the appropriate providers
- Manages screen-level state and lifecycle

## Directory Structure

```text
screens/
├── auth/           # Authentication screens (login, signup, password reset)
├── cart/           # Cart management screens
├── checkout/       # Checkout flow screens
├── home/           # Main home screen and related views
├── product/        # Product browsing and details screens
└── profile/        # User profile and account management screens
```

## Screen Organization Pattern

Each screen follows a consistent organization pattern:

```mermaid
---
config:
  look: classic
  layout: elk
---
flowchart TD
    subgraph Feature Directory
        FeatureScreen["feature_screen.dart\n(Main screen)"]
        Components["components/\n(Screen-specific components)"]
    end
    
    FeatureScreen L_FeatureScreen_Components_0@--> |Contains| Components
    CommonWidgets["../common_widgets/"] L_CommonWidgets_FeatureScreen_0@--> |Provides reusable UI to| FeatureScreen
    Providers["../providers/"] L_Providers_FeatureScreen_0@--> |Supplies data to| FeatureScreen
    
    linkStyle 0 stroke:#42A5F5,fill:none,stroke-width:2px
    linkStyle 1 stroke:#4CAF50,fill:none,stroke-width:2px
    linkStyle 2 stroke:#FFA000,fill:none,stroke-width:2px
    
    L_FeatureScreen_Components_0@{ animation: fast }
    L_CommonWidgets_FeatureScreen_0@{ animation: fast } 
    L_Providers_FeatureScreen_0@{ animation: fast }
```

### Screen Implementation Pattern

Each screen typically follows this structure:

1. **StatelessWidget or ConsumerWidget** - The main screen widget
2. **Screen-specific components** - Smaller widgets used only in this screen
3. **Provider consumption** - Using Riverpod to access application state
4. **Navigation logic** - Handling navigation to/from this screen

## Screen Flow Diagrams

### Authentication Flow

```mermaid
stateDiagram-v2
    [*] --> SplashScreen: Launches app
    SplashScreen --> LoginScreen: Not authenticated
    SplashScreen --> HomeScreen: Already authenticated
    LoginScreen --> SignupScreen: Taps create account
    LoginScreen --> ForgotPasswordScreen: Taps forgot password
    SignupScreen --> VerificationScreen: Completes signup
    ForgotPasswordScreen --> ResetPasswordScreen: Verifies identity
    VerificationScreen --> HomeScreen: Confirms account
    ResetPasswordScreen --> LoginScreen: Updates password
    LoginScreen --> HomeScreen: Authenticates user
    
    note right of SplashScreen: Initial app state check
    note right of LoginScreen: Authentication entry point
    note right of HomeScreen: Main app experience
    
    state SplashScreen {
        [*] --> CheckAuthState
        CheckAuthState --> Redirect
    }
    
    state LoginScreen {
        [*] --> ShowLoginForm
        ShowLoginForm --> ValidateCredentials: Submit
        ValidateCredentials --> ShowError: Invalid
        ValidateCredentials --> ProcessLogin: Valid
    }
```

### Shopping Flow

```mermaid
stateDiagram-v2
    HomeScreen --> CategoryScreen: Browses category
    HomeScreen --> SearchResultsScreen: Performs search
    HomeScreen --> ProductDetailsScreen: Selects featured product
    CategoryScreen --> ProductDetailsScreen: Taps product
    SearchResultsScreen --> ProductDetailsScreen: Chooses search result
    ProductDetailsScreen --> CartScreen: Adds to cart
    CartScreen --> CheckoutScreen: Proceeds to checkout
    CheckoutScreen --> PaymentScreen: Confirms shipping
    PaymentScreen --> OrderConfirmationScreen: Completes payment
    OrderConfirmationScreen --> HomeScreen: Returns to shopping
    OrderConfirmationScreen --> OrderDetailsScreen: Views order details
    
    note right of HomeScreen: Product discovery
    note right of ProductDetailsScreen: Product evaluation
    note right of CartScreen: Purchase preparation
    note right of PaymentScreen: Transaction processing
    
    state ProductDetailsScreen {
        [*] --> LoadProduct
        LoadProduct --> DisplayDetails
        DisplayDetails --> SelectVariants
        SelectVariants --> AddToCart
    }
    
    state CheckoutScreen {
        [*] --> ShowCart
        ShowCart --> SelectAddress
        SelectAddress --> SelectShipping
        SelectShipping --> ReviewOrder
    }
```

### Profile Management Flow

```mermaid
stateDiagram-v2
    HomeScreen --> ProfileScreen: Accesses profile
    ProfileScreen --> EditProfileScreen: Updates info
    ProfileScreen --> AddressesScreen: Manages locations
    ProfileScreen --> PaymentMethodsScreen: Configures payments
    ProfileScreen --> OrderHistoryScreen: Checks past orders
    ProfileScreen --> FavoritesScreen: Views saved items
    OrderHistoryScreen --> OrderDetailsScreen: Examines order
    AddressesScreen --> AddEditAddressScreen: Modifies address
    PaymentMethodsScreen --> AddEditPaymentScreen: Changes payment method
    
    note right of ProfileScreen: Account management hub
    note right of OrderHistoryScreen: Purchase history
    note right of AddressesScreen: Delivery locations
    
    state ProfileScreen {
        [*] --> LoadUserData
        LoadUserData --> DisplayOptions
    }
    
    state OrderHistoryScreen {
        [*] --> FetchOrders
        FetchOrders --> DisplayOrderList
        DisplayOrderList --> FilterOrders
    }
    
  
```

## Key Screen Descriptions

### Home Screen

The main entry point showing featured products, categories, and promotions.

**Features:**

- Product carousels
- Category navigation
- Search functionality
- Promotional banners
- Recently viewed products

### Product Details Screen

Displays detailed information about a specific product.

**Features:**

- Product images gallery
- Product information (name, price, description)
- Color and size selection
- Add to cart functionality
- Reviews and ratings
- Related products

### Cart Screen

Manages the user's shopping cart.

**Features:**

- List of cart items
- Quantity adjustment
- Remove items
- Apply coupons
- Cart summary with totals
- Proceed to checkout

### Checkout Screen

Handles the checkout process.

**Features:**

- Shipping address selection
- Delivery method selection
- Payment method selection
- Order summary
- Coupon application
- Order placement

## Screen Development Guidelines

When adding or modifying screens:

1. **Organization**: Place screens in the appropriate feature directory
2. **Composition**: Compose screens from smaller, focused components
3. **State Management**: Use Riverpod providers for state management
4. **Responsive Design**: Ensure screens adapt to different device sizes
5. **Error Handling**: Implement appropriate error states and messages
6. **Loading States**: Show loading indicators for async operations
7. **Navigation**: Follow the established navigation patterns
8. **Accessibility**: Implement proper accessibility features

## Best Practices

- Keep screen widgets focused on layout and user interaction
- Extract complex UI components into separate widget classes
- Use the common widgets for consistency
- Handle all screen states: loading, success, error, empty
- Implement proper scrolling behavior for various screen sizes
- Use named routes for navigation between screens
- Follow the application's design system
