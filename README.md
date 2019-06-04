# predicate-compiler
Compiles human readable search expressions into some query language

Given example, user types in `age > 5 and age < 10 and status = en`. This expression will be compiled into, e.g. `?age__gt=5&age__lt=10&status=en` when using Django query transformer.

There are should be multiple transformers, for now Django and MongoDB (Stitch) are in priority.
