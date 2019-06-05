module.exports = (...fns) -> (arg) -> fns.reduce ((m, d) -> d(m)), arg
