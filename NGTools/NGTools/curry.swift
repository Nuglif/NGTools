//
//  curry.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in
        return { b in
            return function(a, b)
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments. This version allows the function to throw exceptions.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C>(_ fn: @escaping (A, B) throws -> C) -> (A) -> (B) throws -> C {
    return { a in
        return { b in
            return try fn(a, b)
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D>(_ function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return function(a, b, c)
            }
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments. This version allows the function to throw exceptions.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D>(_ function: @escaping (A, B, C) throws -> D) -> (A) -> (B) -> (C) throws -> D {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return try function(a, b, c)
            }
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D, E>(_ function: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return { (d: D) in
                    return function(a, b, c, d)
                }
            }
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments. This version allows the function to throw exceptions.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D, E>(_ function: @escaping (A, B, C, D) throws -> E) -> (A) -> (B) -> (C) -> (D) throws -> E {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return { (d: D) in
                    return try function(a, b, c, d)
                }
            }
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D, E, F>(_ function: @escaping (A, B, C, D, E) -> F) -> (A) -> (B) -> (C) -> (D) -> (E) -> F {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return { (d: D) in
                    return { (e: E) in
                        return function(a, b, c, d, e)
                    }
                }
            }
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments. This version allows the function to throw exceptions.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D, E, F>(_ function: @escaping (A, B, C, D, E) throws -> F) -> (A) -> (B) -> (C) -> (D) -> (E) throws -> F {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return { (d: D) in
                    return { (e: E) in
                        return try function(a, b, c, d, e)
                    }
                }
            }
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D, E, F, G>(_ function: @escaping (A, B, C, D, E, F) -> G) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return { (d: D) in
                    return { (e: E) in
                        return { (f: F) in
                            return function(a, b, c, d, e, f)
                        }
                    }
                }
            }
        }
    }
}

/// Currying is used to break down a function that has multiple arguments into a series of functions that take part of the arguments. This version allows the function to throw exceptions.
/// - seealso:
/// [Currying](https://medium.com/nuglif/functional-swift-currying-d398a73bf1ed)
public func curry<A, B, C, D, E, F, G>(_ function: @escaping (A, B, C, D, E, F) throws -> G) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) throws -> G {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return { (d: D) in
                    return { (e: E) in
                        return { (f: F) in
                            return try function(a, b, c, d, e, f)
                        }
                    }
                }
            }
        }
    }
}
