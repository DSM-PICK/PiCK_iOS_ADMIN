generate:
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

feature:
	@read -p "Enter feature name: " feature_name; \
	sh Scripts/new_feature.sh $$feature_name

domain:
	@read -p "Enter domain name: " domain_name; \
	sh Scripts/new_domain.sh $$domain_name

