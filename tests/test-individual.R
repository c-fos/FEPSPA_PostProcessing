expect_that(lowLevelProc(c("test1","test2"),list("test3",as.integer(1),as.integer(1))),throws_error())
expect_that(length(dbListConnections(MySQL())),equals(0))