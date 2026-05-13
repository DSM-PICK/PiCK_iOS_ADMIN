generate:
	@if [ ! -d "Projects/App/Resources/Firebase" ]; then \
		echo "❌ Error: Firebase folder not found at Projects/App/Resources/Firebase"; \
		echo "⚠️  This is a required security file. Please add the Firebase folder before generating."; \
		exit 1; \
	fi
	@echo "🔨 Running Needle..."
	@needle generate Projects/App/Sources/Application/DI/NeedleGenerated.swift Projects
	@echo "📦 Installing dependencies..."
	@tuist install
	@echo "🚀 Generating project..."
	@tuist generate

clean:
	tuist clean
	rm -rf .build
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

cache_clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*

needle:
	needle generate Projects/App/Sources/Application/DI/NeedleGenerated.swift Projects

regenerate:
	@if [ ! -d "Projects/App/Resources/Firebase" ]; then \
		echo "❌ Error: Firebase folder not found at Projects/App/Resources/Firebase"; \
		echo "⚠️  This is a required security file. Please add the Firebase folder before generating."; \
		exit 1; \
	fi
	@echo "🧹 Cleaning..."
	@rm -rf **/**/**/*.xcodeproj
	@rm -rf **/**/*.xcodeproj
	@rm -rf **/*.xcodeproj
	@rm -rf *.xcworkspace
	@echo "🔨 Running Needle..."
	@needle generate Projects/App/Sources/Application/DI/NeedleGenerated.swift Projects
	@echo "📦 Installing dependencies..."
	@tuist install
	@echo "🚀 Generating project..."
	@tuist generate

## TDD test targets
## Usage:
##   make test SCHEME=SelfStudyCheckFeature
##   make test-changed          (run tests for features changed since develop)
##   make test-all-features     (run all feature test targets)

SIMULATOR ?= iPhone 16e
WORKSPACE  = PiCK_iOS_ADMIN.xcworkspace

test:
	@if [ -z "$(SCHEME)" ]; then echo "❌ Usage: make test SCHEME=<SchemeName>"; exit 1; fi
	@echo "🧪 Testing $(SCHEME) on $(SIMULATOR)..."
	@xcodebuild test \
		-workspace $(WORKSPACE) \
		-scheme $(SCHEME) \
		-destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
		-resultBundlePath /tmp/$(SCHEME)-result.xcresult \
		2>&1 | grep -E "Test Suite|Test Case|FAILED|error:|warning: |Build succeeded|** TEST" || true
	@echo "✅ $(SCHEME) done"

test-changed:
	@echo "🔍 Detecting changed Feature schemes since develop..."
	@CHANGED=$$(git diff develop...HEAD --name-only | grep 'Projects/Feature/' | \
		sed 's|Projects/Feature/||' | sed 's|/.*||' | sort -u); \
	if [ -z "$$CHANGED" ]; then echo "변경된 Feature 없음"; exit 0; fi; \
	for f in $$CHANGED; do \
		SCHEME="$$f"; \
		echo "🧪 Testing $$SCHEME..."; \
		xcodebuild test \
			-workspace $(WORKSPACE) \
			-scheme $$SCHEME \
			-destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
			2>&1 | grep -E "Test Suite|FAILED|error:|** TEST" || true; \
	done; \
	echo "✅ test-changed 완료"

test-all-features:
	@for scheme in SelfStudyCheckFeature BugReportFeature CheckSelfStudyTeacherFeature \
		SchoolMealFeature ClassroomMoveListFeature OutListFeature OutingHistoryFeature \
		AcceptFeature SigninFeature SignupFeature ChangePasswordFeature; do \
		echo "🧪 Testing $$scheme..."; \
		xcodebuild test \
			-workspace $(WORKSPACE) \
			-scheme $$scheme \
			-destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
			2>&1 | grep -E "Test Suite|FAILED|error:|** TEST" || true; \
	done; \
	echo "✅ 전체 feature 테스트 완료"

feature:
	@read -p "Enter feature name: " feature_name; \
	sh Scripts/new_feature.sh $$feature_name

domain:
	@read -p "Enter domain name: " domain_name; \
	sh Scripts/new_domain.sh $$domain_name

delete:
	@sh Scripts/delete_module.sh

