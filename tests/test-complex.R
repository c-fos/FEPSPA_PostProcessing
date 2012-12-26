expect_that(1 ^ 1, equals(1))
expect_that(2 ^ 2, equals(4))

expect_that(2 + 2 == 4, is_true())
expect_that(2 == 1, is_false())

expect_that(1, is_a('numeric'))

expect_that(print('Hello World!'), prints_text('Hello World!'))

expect_that(log('a'), throws_error())

expect_that(higthLev, equals(0))
# expect_that(hightLevelProc(0,0), throws_error())
# expect_that(hightLevelProc(list(),list()), throws_error())
# expect_that(hightLevelProc(list(1,2,3),list(1,2,3)), throws_error())