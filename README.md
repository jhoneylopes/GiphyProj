# GiphyProj

[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)

## About Application:

GiphyProj is an iOS application that you can use to search for GIFs and favorite them;
I've used this project to learn a little about Code generation(Tuis.io), MicroFeature and try something new using Reactive concepts;

Requirements:

- Xcode 12
- Swift 5

## Details:

- Tuis.io project generation to help with conflict mitigation in a team environment;
- Separate framework modules for isolating code and delitiming responsibilities/property accessors:
    - App: Main target with executable and initialization code;
    - Core: Provider*, Reusable extensions, internal libs, constants and mechanisms in the app;
        - Provider: Network and database access and abstractions for any data input;
    - Features: Presentation and business layer code;
    
- MVVM+Coordinators+Rx;
- Dependency injection pattern;
- ViewCode for better UI componentization;
- Unit tests;

## Setup:

I let 2 branches, one to setup using Tuist.io and another with the whole structure:

**Full Experience**

- Branch: `feature/project-to-be-generated`

Xcodeproj, Workspace... and Dependencies will be created local by script. 
After you have cloned the project, run on terminal:

1. Setup Tuist.io env: $`bash <(curl -Ls https://install.tuist.io)`
2. Run: $`tuist generate`

**All Ready**

- Branch: `feature/project-all-ready`

The whole project is over there.

## Features:
- Most Viewed tab: lets you search for any GIF on Giphy API;
- Favorites tab: shows your favorited GIFs.

## Things to improve:
- Create an AppAction to dispatch AppState updates and encapsulate business logic in ViewModel
- Make more advanced usage of the RX API (creating reactive components, better error treatment, etc)
- Add UITests for basic flow;
- Add snapshot tests;
