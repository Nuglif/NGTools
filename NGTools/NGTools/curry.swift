//
//  curry.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

public func curry<A,B,C>(function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in
        return { b in
            return function(a, b)
        }
    }
}

public func curry<A,B,C, D>(function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { (a: A) in
        return { (b: B) in
            return { (c: C) in
                return function(a, b, c)
            }
        }
    }
}

public func curry<A,B,C, D, E>(function: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
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

public func curry<A,B,C, D, E, F>(function: @escaping (A, B, C, D, E) -> F) -> (A) -> (B) -> (C) -> (D) -> (E) -> F {
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

public func curry<A, B, C, D, E, F, G>(_ fn: @escaping (A, B, C, D, E, F) -> G) -> (A, B, C) -> (D) -> (E) -> (F) -> G {
    return { (a, b, c) in
        return { d in
            return { e in
                return { f in
                    return fn(a, b, c, d, e, f)
                }
            }
        }
    }
}
