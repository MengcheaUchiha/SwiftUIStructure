#!/bin/bash

#  generate_module.sh
#  SwiftUIStructure
#
#  Created by Mengchea Saro on 12/6/26.
#

# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
AUTHOR_NAME="Mengchea Saro"   # Replace with your actual name
PROJECT_NAME="SwiftUIStructure"        # Replace with your app's name
CENTRAL_DI_FILE="DI/DIContainer.swift" # <-- VERIFY THIS PATH TO YOUR EXISTING FILE
CENTRAL_NETWORK_FILE="DI/NetworkContainer.swift" # <-- VERIFY NETWORK CONTAINER PATH
CURRENT_DATE=$(date +"%m/%d/%y") # Generates format like 10/5/26
# ---------------------

# Prompt user for the module name if not passed as an argument
if [ -z "$1" ]
then
    read -p "Enter module name (e.g., User): " MODULE_NAME
else
    MODULE_NAME=$1
fi

# Ensure the first letter is capitalized
MODULE_NAME="$(tr '[:lower:]' '[:upper:]' <<< "${MODULE_NAME:0:1}")${MODULE_NAME:1}"

# Define lowercase plural/singular variations for endpoints/methods
MODULE_NAME_LOWER=$(echo "$MODULE_NAME" | tr '[:upper:]' '[:lower:]')
MODULE_NAME_PLURAL_LOWER="${MODULE_NAME_LOWER}s"

echo "🚀 Generating Clean Architecture layers for: ${MODULE_NAME}..."

# 1. Create Folder Structure
mkdir -p API
mkdir -p Domain/DataSource
mkdir -p Domain/Repository
mkdir -p Domain/UseCase
mkdir -p Presentation/"$MODULE_NAME"/View
mkdir -p Presentation/"$MODULE_NAME"/ViewModel
mkdir -p Presentation/"$MODULE_NAME"/Model
mkdir -p DI

# -----------------------------------------------------------------------------
# Data Layer
# -----------------------------------------------------------------------------

# API Target
FILE_API="${MODULE_NAME}API.swift"
cat << EOF > "API/${FILE_API}"
//
//  ${FILE_API}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import Foundation
import Moya
internal import Alamofire

enum ${MODULE_NAME}API: TargetType {
    case ${MODULE_NAME_PLURAL_LOWER}
    
    var baseURL: URL { return Configuration.baseURL }
    
    var path: String {
        switch self {
        case .${MODULE_NAME_PLURAL_LOWER}: return "/${MODULE_NAME_PLURAL_LOWER}"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return [:]
    }
}
EOF

# Remote Data Source
FILE_DATASOURCE="${MODULE_NAME}DataSource.swift"
cat << EOF > "Domain/DataSource/${FILE_DATASOURCE}"
//
//  ${FILE_DATASOURCE}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import Moya
import Foundation

protocol ${MODULE_NAME}RemoteDataSource {
    func fetch${MODULE_NAME}s() async throws -> [${MODULE_NAME}Model]
}

final class ${MODULE_NAME}RemoteDataSourceImpl: ${MODULE_NAME}RemoteDataSource {
    private let provider: NetworkProvider<${MODULE_NAME}API>

    init(provider: NetworkProvider<${MODULE_NAME}API>) {
        self.provider = provider
    }

    func fetch${MODULE_NAME}s() async throws -> [${MODULE_NAME}Model] {
        let response = try await provider.request(.${MODULE_NAME_PLURAL_LOWER})
        return try JSONDecoder().decode([${MODULE_NAME}Model].self, from: response.data)
    }
}
EOF

# Repository Interface & Implementation
FILE_REPO_IMPL="${MODULE_NAME}Repository.swift"
cat << EOF > "Domain/Repository/${FILE_REPO_IMPL}"
//
//  ${FILE_REPO_IMPL}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import Moya
import Foundation

protocol ${MODULE_NAME}Repository {
    func fetch${MODULE_NAME}s() async throws -> [${MODULE_NAME}Model]
}

class ${MODULE_NAME}RepositoryImpl: ${MODULE_NAME}Repository {
    let remote: ${MODULE_NAME}RemoteDataSource
    
    init(remote: ${MODULE_NAME}RemoteDataSource) {
        self.remote = remote
    }
    
    func fetch${MODULE_NAME}s() async throws -> [${MODULE_NAME}Model] {
        return try await remote.fetch${MODULE_NAME}s()
    }
}
EOF

# -----------------------------------------------------------------------------
# Domain Layer
# -----------------------------------------------------------------------------

# Use Case
FILE_USECASE="${MODULE_NAME}UseCase.swift"
cat << EOF > "Domain/UseCase/${FILE_USECASE}"
//
//  ${FILE_USECASE}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import Moya
import Foundation

protocol ${MODULE_NAME}sUseCase {
    func fetch${MODULE_NAME}s() async throws -> [${MODULE_NAME}Model]
}

final class ${MODULE_NAME}sUseCaseImpl: ${MODULE_NAME}sUseCase {
    private let repository: ${MODULE_NAME}Repository

    init(repository: ${MODULE_NAME}Repository) {
        self.repository = repository
    }

    func fetch${MODULE_NAME}s() async throws -> [${MODULE_NAME}Model] {
        try await repository.fetch${MODULE_NAME}s()
    }
}
EOF

# -----------------------------------------------------------------------------
# Presentation Layer
# -----------------------------------------------------------------------------

# View
FILE_VIEW="${MODULE_NAME}View.swift"
cat << EOF > "Presentation/${MODULE_NAME}/View/${FILE_VIEW}"
//
//  ${FILE_VIEW}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import SwiftUI

struct ${MODULE_NAME}View: View {
    @StateObject var viewModel: ${MODULE_NAME}ViewModel
    
    var body: some View {
        AsyncContentView(
            source: viewModel,
            loadingView: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.0, anchor: .center)
            }, errorView: { error in
                errorView(error: error.localizedDescription)
            }) { albums in
                contentView(for: albums)
            }
    }
    
}

extension ${MODULE_NAME}View {
    
    func contentView(for items: [${MODULE_NAME}Model]) -> some View {
        return ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(items, id: \.id) { album in
                    Text("\(album.id)")
                }
            }
            .navigationTitle("Albums")
        }
    }
    
    func errorView(error: String) -> some View {
        return VStack {
            Text("Something went wrong.")
                .font(.title3)
                .foregroundColor(.red)
            
            Text(error)
        }
    }
    
}

#Preview {
    ${MODULE_NAME}View(viewModel: DIContainer.shared.${MODULE_NAME_LOWER}Container.make${MODULE_NAME}sViewModel)
}

EOF

# ViewModel
FILE_VIEWMODEL="${MODULE_NAME}ViewModel.swift"
cat << EOF > "Presentation/${MODULE_NAME}/ViewModel/${FILE_VIEWMODEL}"
//
//  ${FILE_VIEWMODEL}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import Foundation
import Combine
import Moya
import SwiftUI

@MainActor
class ${MODULE_NAME}ViewModel: LoadableObject {
    @Published private(set) var state = LoadingState<[${MODULE_NAME}Model]>.idle
    @Published var loaded${MODULE_NAME}s: [${MODULE_NAME}Model] = []
    
    private let ${MODULE_NAME_LOWER}UseCase: ${MODULE_NAME}sUseCase

    init(${MODULE_NAME_LOWER}UseCase: ${MODULE_NAME}sUseCase) {
        self.${MODULE_NAME_LOWER}UseCase = ${MODULE_NAME_LOWER}UseCase
    }
    
    func get${MODULE_NAME}s() {
        if Configuration.isPreview {
            state = .loaded([
                ${MODULE_NAME}Model(id: 1),
                ${MODULE_NAME}Model(id: 2)
            ])
            return
        }
        
        if case .idle = state {
            state = .loading
        }
        
        Swift.Task {
            do {
                let ${MODULE_NAME_PLURAL_LOWER} = try await ${MODULE_NAME_LOWER}UseCase.fetch${MODULE_NAME}s()
                loaded${MODULE_NAME}s = loaded${MODULE_NAME}s + ${MODULE_NAME_PLURAL_LOWER}
                state = .loaded(loaded${MODULE_NAME}s)
            } catch {
                print("Error: \(error.localizedDescription)")
                state = .failed(error)
            }
        }
    }
}
EOF

# Model
FILE_MODEL="${MODULE_NAME}Model.swift"
cat << EOF > "Presentation/${MODULE_NAME}/Model/${FILE_MODEL}"
//
//  ${FILE_MODEL}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import Foundation

struct ${MODULE_NAME}Model: Codable, Hashable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
    }
    
    init(id: Int) {
        self.id = id
    }
}
EOF

# -----------------------------------------------------------------------------
# Dependency Injection Layer
# -----------------------------------------------------------------------------

FILE_DI="${MODULE_NAME}Container.swift"
cat << EOF > "DI/${FILE_DI}"
//
//  ${FILE_DI}
//  ${PROJECT_NAME}
//
//  Created by ${AUTHOR_NAME} on ${CURRENT_DATE}.
//

import Foundation

// MARK: - ${MODULE_NAME} Container

final class ${MODULE_NAME}Container {

    private let network: NetworkContainer

    init(network: NetworkContainer) {
        self.network = network
    }

    // MARK: Data Sources

    lazy var ${MODULE_NAME_LOWER}RemoteDataSource: ${MODULE_NAME}RemoteDataSource = {
        ${MODULE_NAME}RemoteDataSourceImpl(
            provider: network.${MODULE_NAME_LOWER}NetworkProvider
        )
    }()

    // MARK: Repositories

    lazy var ${MODULE_NAME_LOWER}Repository: ${MODULE_NAME}Repository = {
        ${MODULE_NAME}RepositoryImpl(
            remote: ${MODULE_NAME_LOWER}RemoteDataSource
        )
    }()

    // MARK: UseCases

    lazy var fetch${MODULE_NAME}sUseCase: ${MODULE_NAME}sUseCase = {
        ${MODULE_NAME}sUseCaseImpl(
            repository: ${MODULE_NAME_LOWER}Repository
        )
    }()

    // MARK: ViewModels

    @MainActor
    func make${MODULE_NAME}sViewModel() -> ${MODULE_NAME}ViewModel {
        ${MODULE_NAME}ViewModel(
            ${MODULE_NAME_LOWER}UseCase: fetch${MODULE_NAME}sUseCase
        )
    }
    
}
EOF

# -----------------------------------------------------------------------------
# Append Code Snippet to Existing NetworkContainer.swift
# -----------------------------------------------------------------------------

if [ -f "$CENTRAL_NETWORK_FILE" ]; then
    if grep -q "lazy var ${MODULE_NAME_LOWER}Provider" "$CENTRAL_NETWORK_FILE"; then
        echo "ℹ️  ${MODULE_NAME}Provider already mapped in NetworkContainer.swift."
    else
        echo "⚙️  Appending provider code blocks into ${CENTRAL_NETWORK_FILE}..."
        awk -v name="$MODULE_NAME" -v lower="$MODULE_NAME_LOWER" '
        /^[[:space:]]*\}[[:space:]]*$/ { last_brace_line = NR }
        { lines[NR] = $0 }
        END {
            for (i = 1; i <= NR; i++) {
                if (i == last_brace_line) {
                    print "    lazy var " lower "Provider: MoyaProvider<" name "API> = {"
                    print "        MoyaProvider<" name "API>("
                    print "            plugins: plugins"
                    print "        )"
                    print "    }()"
                    print ""
                    print "    lazy var " lower "NetworkProvider: NetworkProvider<" name "API> = {"
                    print "        NetworkProvider<" name "API>("
                    print "            provider: " lower "Provider,"
                    print "        )"
                    print "    }()"
                    print ""
                }
                print lines[i]
            }
        }' "$CENTRAL_NETWORK_FILE" > "${CENTRAL_NETWORK_FILE}.tmp" && mv "${CENTRAL_NETWORK_FILE}.tmp" "$CENTRAL_NETWORK_FILE"
    fi
else
    echo "⚠️  Could not locate ${CENTRAL_NETWORK_FILE}. Skipping network configuration step."
fi

# -----------------------------------------------------------------------------
# Append Code Snippet to Existing DIContainer.swift
# -----------------------------------------------------------------------------

if [ -f "$CENTRAL_DI_FILE" ]; then
    # Prevent duplicate code injection if module is run twice
    if grep -q "lazy var ${MODULE_NAME_LOWER}Container" "$CENTRAL_DI_FILE"; then
        echo "ℹ️  ${MODULE_NAME}Container already mapped in DIContainer.swift."
    else
        echo "⚙️  Appending container mapping code block directly into ${CENTRAL_DI_FILE}..."
        
        awk -v name="$MODULE_NAME" -v lower="$MODULE_NAME_LOWER" '
        # Track the line position of the last absolute closing brace
        /^[[:space:]]*\}[[:space:]]*$/ { last_brace_line = NR }
        { lines[NR] = $0 }
        END {
            for (i = 1; i <= NR; i++) {
                if (i == last_brace_line) {
                    print "    lazy var " lower "Container: " name "Container = {"
                    print "        " name "Container(network: networkContainer)"
                    print "    }()"
                    print ""
                }
                print lines[i]
            }
        }' "$CENTRAL_DI_FILE" > "${CENTRAL_DI_FILE}.tmp" && mv "${CENTRAL_DI_FILE}.tmp" "$CENTRAL_DI_FILE"
    fi
else
    echo "⚠️  Could not locate ${CENTRAL_DI_FILE}. Skipping code injection step."
fi

echo "✅ Success! Files created and registered inside your existing DIContainer configuration."

# Check if XcodeGen is available and execute it automatically
if command -v xcodegen &> /dev/null; then
    echo "🔄 Auto-syncing with XcodeGen..."
    cd /Users/mengchea.sar/Documents/SwiftUI/SwiftUIStructure/SwiftUIStructure/ xcodegen generate
fi

# Uncomment the line below to automatically run xcodegen after generating the files!
# xcodegen generate
