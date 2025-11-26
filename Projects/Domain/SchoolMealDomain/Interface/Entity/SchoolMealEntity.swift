import Foundation

public struct SchoolMealEntity: Equatable {
    public let meals: SchoolMealEntityElement

    public init(meals: SchoolMealEntityElement) {
        self.meals = meals
    }
}

public struct SchoolMealEntityElement: Equatable {
    public let mealBundle: [(String, MealEntityElement)]

    public init(mealBundle: [(String, MealEntityElement)]) {
        self.mealBundle = mealBundle
    }
    
    public static func == (lhs: SchoolMealEntityElement, rhs: SchoolMealEntityElement) -> Bool {
        guard lhs.mealBundle.count == rhs.mealBundle.count else { return false }
        for (index, element) in lhs.mealBundle.enumerated() {
            if element.0 != rhs.mealBundle[index].0 || element.1 != rhs.mealBundle[index].1 {
                return false
            }
        }
        return true
    }
}

public struct MealEntityElement: Equatable {
    public let menu: [String]
    public let kcal: String

    public init(menu: [String], kcal: String) {
        self.menu = menu
        self.kcal = kcal
    }
}
