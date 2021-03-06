# VicmapR 0.1.1

* `options(vicmap.base_url)` now accepts other base wfs urls to be used instead of the Vicplan one (e.g. the BOM wfs: `options(vicmap.base_url = "http://geofabric.bom.gov.au/simplefeatures/ahgf_shcatch/wfs")`)  
* A vignette on how to use Vicmap has been added
* Enhanced documentation and references
* Specified that GDAL > 3.0.0 is required  
* Additional tests have been written

# VicmapR 0.1.0

* VicmapR now buidls queries in a step-wise fashion through the use of a `vicmap_promise` class. Similar to how [bcdata](https://github.com/bcgov/bcdata) works 
* Generic functions like `filter`, `select`, `head` can be used to refine the query.
* Data is returned using `collect`
* No longer relying on the `ows4R` package
* Other supporting functions such as `feature_cols`, `feature_hits`, `show_query` exist to help refine a query

# VicmapR 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package  
* Wrote functions for basic WFS querying of data names and fields (`listLayers` and `listFields`)  
* Wrote a function to download and read in spatial data from Vicmap as `sf` objects (`read_layer_sf`)  

