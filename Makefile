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
	@rm -rf /tmp/$(SCHEME)-result.xcresult
	@RESULT=$$(xcodebuild test \
		-workspace $(WORKSPACE) \
		-scheme $(SCHEME) \
		-destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
		-resultBundlePath /tmp/$(SCHEME)-result.xcresult \
		2>&1); \
	echo "$$RESULT" | grep -E "Test Suite|Test Case|FAILED|error:|BUILD SUCCEEDED|BUILD FAILED" || true; \
	if echo "$$RESULT" | grep -q "TEST SUCCEEDED"; then \
		echo "  ✅ $(SCHEME) PASSED"; \
	else \
		echo "  ❌ $(SCHEME) FAILED"; \
		exit 1; \
	fi
	@echo "✅ $(SCHEME) done"

# 디렉토리명 → 스킴명 매핑 (BugReport→BugReportFeature 등)
_scheme_for_dir = $(shell echo "$(1)" | sed \
	-e 's/^BugReport$$/BugReportFeature/' \
	-e 's/^SelfStudyCheck$$/SelfStudyCheckFeature/' \
	-e 's/^ChangePassword$$/ChangePasswordFeature/')

test-changed:
	@echo "🔍 Detecting changed Feature schemes since develop..."
	@CHANGED=$$(git diff develop...HEAD --name-only | grep 'Projects/Feature/' | \
		sed 's|Projects/Feature/||' | sed 's|/.*||' | sort -u); \
	if [ -z "$$CHANGED" ]; then echo "변경된 Feature 없음"; exit 0; fi; \
	PASS=0; FAIL=0; \
	for dir in $$CHANGED; do \
		SCHEME=$$(echo "$$dir" | sed \
			-e 's/^BugReport$$/BugReportFeature/' \
			-e 's/^SelfStudyCheck$$/SelfStudyCheckFeature/' \
			-e 's/^ChangePassword$$/ChangePasswordFeature/'); \
		echo "🧪 Testing $$SCHEME..."; \
		RESULT=$$(xcodebuild test \
			-workspace $(WORKSPACE) \
			-scheme $$SCHEME \
			-destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
			2>&1); \
		if echo "$$RESULT" | grep -q "TEST SUCCEEDED"; then \
			echo "  ✅ $$SCHEME PASSED"; PASS=$$((PASS+1)); \
		elif echo "$$RESULT" | grep -q "TEST FAILED\|BUILD FAILED"; then \
			echo "  ❌ $$SCHEME FAILED"; \
			echo "$$RESULT" | grep -E "error:|FAILED" | head -10; \
			FAIL=$$((FAIL+1)); \
		else \
			echo "  ⚠️  $$SCHEME — 결과 불명확 (no test target?)"; \
		fi; \
	done; \
	echo ""; \
	echo "결과: ✅ $$PASS passed / ❌ $$FAIL failed"; \
	[ $$FAIL -eq 0 ]

test-all-features:
	@PASS=0; FAIL=0; \
	for scheme in SelfStudyCheckFeature BugReportFeature CheckSelfStudyTeacherFeature \
		SchoolMealFeature ClassroomMoveListFeature OutListFeature OutingHistoryFeature \
		AcceptFeature SigninFeature SignupFeature ChangePasswordFeature; do \
		echo "🧪 Testing $$scheme..."; \
		RESULT=$$(xcodebuild test \
			-workspace $(WORKSPACE) \
			-scheme $$scheme \
			-destination 'platform=iOS Simulator,name=$(SIMULATOR)' 2>&1); \
		if echo "$$RESULT" | grep -q "TEST SUCCEEDED"; then \
			echo "  ✅ $$scheme PASSED"; PASS=$$((PASS+1)); \
		else \
			echo "  ❌ $$scheme FAILED"; FAIL=$$((FAIL+1)); \
		fi; \
	done; \
	echo ""; \
	echo "결과: ✅ $$PASS passed / ❌ $$FAIL failed"; \
	[ $$FAIL -eq 0 ]

feature:
	@read -p "Enter feature name: " feature_name; \
	sh Scripts/new_feature.sh $$feature_name

domain:
	@read -p "Enter domain name: " domain_name; \
	sh Scripts/new_domain.sh $$domain_name

delete:
	@sh Scripts/delete_module.sh

