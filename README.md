# SwiftUIStructure

# 🚀 iOS Clean Architecture & DI Generator

A set of automated bash scripts designed to completely eliminate boilerplate work when building iOS applications using **Clean Architecture** and **Dependency Injection**. 

These scripts instantly scaffold standardized Data, Domain, and Presentation layers, generate a dedicated DI container for the module, and automatically register the new dependencies into your app's root central containers.

---

## 🏗️ Architecture Design & Directory Layout

When you generate a new module (e.g., `User`), the script creates the following structure:

```text
├── API/
│   └── UserAPI.swift                      # Moya TargetType endpoints
├── Domain/        
│   ├── DataSource/UserDataSource.swift    # Remote data source implementations
│   ├── Repository/UserRepository.swift    # Repository implementation
│   └── UseCase/UserUseCase.swift          # Domain business logic (UseCases)
├── Presentation/
│   └── User/                              # UI Module
│       ├── View/UserView.swift            # SwiftUI View
│       ├── ViewModel/UserViewModel.swift  # MainActor ObservableObject
│       └── Model/UserModel.swift          # Codable Data Model
└── DI/
    ├── UserContainer.swift                # Dedicated standalone module container
    ├── DIContainer.swift                  # (Appended automatically)
    └── NetworkContainer.swift             # (Appended automatically)
```


## 🛠️ Prerequisites
XcodeGen (Highly Recommended): To ensure files appear instantly inside Xcode without manual drag-and-drop operations, these scripts are built to auto-sync with XcodeGen.

## brew install xcodegen

Project Structure:
Make sure your project.yml file and these scripts are placed together in the same root directory of your project.

## ⚙️ Setup & Installation
Before running the scripts for the first time, you must grant them execution permissions on your Mac. Open your terminal at your project's root directory and run:

chmod +x generate_module.sh
chmod +x remove_module.sh

## Generate script
```text
./generate_module.sh User
```

## Remove script
```text
./remove_module.sh User
```