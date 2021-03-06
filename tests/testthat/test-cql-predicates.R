# Tests here have been implemented from bcdata: https://github.com/bcgov/bcdata/blob/master/tests/testthat/test-cql-string.R

suppressPackageStartupMessages(library(sf, quietly = TRUE))

the_geom <- st_sf(st_sfc(st_point(c(1,1)))) %>% `st_crs<-`(4283)

test_that("vicmap_cql_string fails when an invalid arguments are given",{
  expect_error(VicmapR:::vicmap_cql_string(the_geom, "FOO"))
  expect_error(VicmapR:::vicmap_cql_string(quakes, "DWITHIN"))
})

test_that("vicmap_cql_string fails when used on an uncollected (promise) object", {
  expect_error(VicmapR:::vicmap_cql_string(structure(list, class = "vicmap_promise")),
               "you need to use collect")
})

test_that("CQL function works", {
  expect_is(CQL("SELECT * FROM foo;"), c("CQL", "SQL"))
})

test_that("All cql geom predicate functions work", {
  single_arg_functions <- c("EQUALS","DISJOINT","INTERSECTS",
                            "TOUCHES", "CROSSES", "WITHIN",
                            "CONTAINS", "OVERLAPS")
  for (f in single_arg_functions) {
    expect_equal(
      do.call(f, list(the_geom)),
      CQL(paste0(f, "({geom_name}, POINT (1 1))"))
    )
  }
  expect_equal(
    DWITHIN(the_geom, 1), #default units meters
    CQL("DWITHIN({geom_name}, POINT (1 1), 1, meters)")
  )
  expect_equal(
    DWITHIN(the_geom, 1, "meters"),
    CQL("DWITHIN({geom_name}, POINT (1 1), 1, meters)")
  )
  expect_equal(
    BEYOND(the_geom, 1, "feet"),
    CQL("BEYOND({geom_name}, POINT (1 1), 1, feet)")
  )
  expect_equal(
    RELATE(the_geom, "*********"),
    CQL("RELATE({geom_name}, POINT (1 1), *********)")
  )
  expect_equal(
    BBOX(c(1,2,1,2)),
    CQL("BBOX({geom_name}, 1, 2, 1, 2)")
  )
  expect_equal(
    BBOX(c(1,2,1,2), crs = 'EPSG:4326'),
    CQL("BBOX({geom_name}, 1, 2, 1, 2, 'EPSG:4326')")
  )
  expect_equal(
    BBOX(c(1,2,1,2), crs = 4326),
    CQL("BBOX({geom_name}, 1, 2, 1, 2, 'EPSG:4326')")
  )
})

test_that("CQL functions fail correctly", {
  expect_error(EQUALS(quakes), "x is not a valid sf object")
  expect_error(BEYOND(the_geom, "five"), "'distance' must be numeric")
  expect_error(DWITHIN(the_geom, 5, "fathoms"), "'arg' should be one of")
  expect_error(DWITHIN(the_geom, "10", "meters"), "must be numeric")
  expect_error(RELATE(the_geom, "********"), "pattern") # 8 characters
  expect_error(RELATE(the_geom, "********5"), "pattern") # invalid character
  expect_error(RELATE(the_geom, rep("TTTTTTTTT", 2)), "pattern") # > length 1
  expect_error(BBOX(c(1,2,3)), "numeric vector")
  expect_error(BBOX(c("1","2","3", "4")), "numeric vector")
  expect_error(BBOX(c(1,2,3,4), crs = c("EPSG:4326", "EPSG:3005")),
               "must be a character string")
})

test_that("passing an non-existent object to a geom predicate", {
  skip_if_offline()
  expect_error(vicmap_query("datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
                 filter(INTERSECTS(districts)),
               'object "districts" not found.\nThe object passed to INTERSECTS needs to be valid sf object.')
})

test_that("CQL translate works", {
  expect_is(VicmapR:::cql_translate(CQL(INTERSECTS(the_geom))), c("sql", "character"))
})
