[![Swift 5](https://img.shields.io/badge/swift-5-red.svg?style=flat)](https://developer.apple.com/swift)

# HSE App

## Author
Dmitrii Sokolov

## Requirements

- iOS 14.6+
- Xcode 13.0+
- Swift 5.0+

## Project Structure

    .
    ├── Main                  # App & Scene Delegate, base controller
    ├── Modules               # Modules: chat,login,schedule etc...
    ├── Networking            # Network Layer
    ├── Utilities             # Extensions and custom components
    └── Assets               # fonts, colors, symbols
    
## Network Layer

    .
    ├── EndPoint              # Concrete information for specific request/endpoint
    ├── Manager               # manager to make/cancel API calls
    ├── Service               # Constructing and performing generic request 
    └── Encoding              # Encoding URL/JSON  
    
## Preview

## Description
HSE application for Students/Assistants/Professor to efficently interact with each other, check timetable and pass deadlines

## SPM Dependencies

- HSESKIT

