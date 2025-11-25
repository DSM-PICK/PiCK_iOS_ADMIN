generate:
	tuist install
	tuist generate

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
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	tuist install
	tuist generate

feature:
	@read -p "Enter feature name: " feature_name; \
	sh Scripts/new_feature.sh $$feature_name

