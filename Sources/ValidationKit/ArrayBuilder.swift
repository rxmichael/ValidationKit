//
//  ArrayBuilder.swift
//
//
//  Created by Michael Eid on 7/4/24.
//

@resultBuilder
public struct ArrayBuilder<T> {
    public typealias Component = [T]

    public static func buildExpression(_ expression: T) -> Component {
        [expression]
    }

    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [Component]) -> Component {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }

    public static func buildEither(first component: Component) -> Component {
        component
    }

    public static func buildEither(second component: Component) -> Component {
        component
    }
}
