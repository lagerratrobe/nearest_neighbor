## Nearest Neighbor Project Notes

## Goal

Determine nearest N objects to a given set of coordinates.

## Ideal Conditions

-   No need for spatial libraries
-   Fast!!
    -   probably requires some sort indexing or pseudo-indexing
-   Small enough data set to store in Github [format uncertain]

## Data Discovery

Downloaded hospitals.shp data from `https://hifld-geoplatform.opendata.arcgis.com/datasets/geoplatform::hospitals-2/about`.

**Spatial Summary:**

    ogrinfo -summary ./ hospitals
    Layer name: hospitals
    Metadata:
      DBF_DATE_LAST_UPDATE=2022-04-08
    Geometry: Point
    Feature Count: 7596
    Extent: (-19663504.130700, -1607536.442400) - (16221974.063000, 11504847.840500)
    Layer SRS WKT:
    PROJCRS["WGS 84 / Pseudo-Mercator",
        ID["EPSG",3857]]

**Feature Details:**

    OGRFeature(hospitals):7426
      ID (String) = 0009898104
      NAME (String) = HARBORVIEW MEDICAL CENTER
      ADDRESS (String) = 325 9TH AVE
      CITY (String) = SEATTLE
      STATE (String) = WA
      ZIP (String) = 98104
      ZIP4 (String) = NOT AVAILABLE
      TELEPHONE (String) = (206) 731-3000
      TYPE (String) = GENERAL ACUTE CARE
      STATUS (String) = OPEN
      POPULATION (Integer) = 413
      COUNTY (String) = KING
      COUNTYFIPS (String) = 53033
      COUNTRY (String) = USA
      LATITUDE (Real) = 47.603860146000045
      LONGITUDE (Real) = -122.323988921999955
      NAICS_CODE (String) = 622110
      NAICS_DESC (String) = GENERAL MEDICAL AND SURGICAL HOSPITALS
      SOURCE (String) = https://fortress.wa.gov/doh/facilitysearch/default.aspx
      SOURCEDATE (Date) = 2019/08/10
      VAL_METHOD (String) = IMAGERY
      VAL_DATE (Date) = 2020/04/06
      WEBSITE (String) = www.uwmedicine.org
      STATE_ID (String) = 29
      ALT_NAME (String) = SWEDISH MEDICAL CENTER - FIRST HILL
      ST_FIPS (String) = 53
      OWNER (String) = GOVERNMENT - LOCAL
      TTL_STAFF (Integer) = -999
      BEDS (Real) = 413.000000000000000
      TRAUMA (String) = LEVEL I, LEVEL I PEDIATRIC, LEVEL I REHAB
      HELIPAD (String) = Y
      POINT (-13617044.1586 6041202.4976)

## Data Preparation

**Notes:**

-   Way more fields than we need. Keep just the following
    -   ID (String) = 0009898104
    -   NAME (String) = HARBORVIEW MEDICAL CENTER
    -   ADDRESS (String) = 325 9TH AVE
    -   CITY (String) = SEATTLE
    -   STATE (String) = WA
    -   COUNTY (String) = KING
    -   ZIP (String) = 98104
    -   TYPE (String) = GENERAL ACUTE CARE
    -   STATUS (String) = OPEN
    -   LATITUDE (Real) = 47.603860146000045
    -   LONGITUDE (Real) = -122.323988921999955
    -   BEDS (Real) = 413.000000000000000
    -   TRAUMA (String) = LEVEL I, LEVEL I PEDIATRIC, LEVEL I REHAB
    -   HELIPAD (String) = Y
-   Make sure that we set appropriate data types once we've loaded the data into R

**Initial Data Processing:**

* See `R/data_processing.R`
* Outputs saved to `Data/usa_hospitals.RDS`
```
# Example record
$ ID        <chr> "0005793230"
$ NAME      <chr> "CENTRAL VALLEY GENERAL HOSPITAL"
$ ADDRESS   <chr> "1025 NORTH DOUTY STREET"
$ CITY      <chr> "HANFORD"
$ STATE     <chr> "CA"
$ COUNTY    <chr> "KINGS"
$ ZIP       <chr> "93230"
$ TYPE      <chr> "GENERAL ACUTE CARE"
$ STATUS    <chr> "CLOSED"
$ LATITUDE  <dbl> 36.33616
$ LONGITUDE <dbl> -119.6457
$ BEDS      <int> 49
$ TRAUMA    <chr> "NOT AVAILABLE"
$ HELIPAD   <chr> "N"
```

## Nearest Neighbor Implementation

__GOAL:__

I need a function that can take a (LATITIDE, LONGITUDE) pair as inputs and return the "nearest" hospitals to 
it.  (I say "nearest" because I'm not sure right now what that means.)  

For simplicity, let's stipulate the following:
  * return the 5 nearest hospitals that are within 250 miles of any given point

In the past, I've heard people say that the want the "5 closest" features returned - no matter how far away they are.  That's just stupid.  Why?  Because the goal of the tool is to capture whether or not an object exists that is "relatively nearby", not to determine whether the closest object is halfway around the planet from us.  Basically, if it's further than 250 miles away, we don't give a shit.

__COORDINATE INDEXING APPROACH:__

My initial approach is to select features from the data set whose coordinate values are within a specific numeric distance.  So for example if my starting location is (47.524384, -122.374334)  and my target hospital is at (47.6518, -117.4234), the straight-line distance between them is roughly 231 miles. (As calculated using a haversine distance function.)

## Testing

Before I go off and figure out a non-spatial way to do this, let's see what our results SHOULD be by using a proper spatial library, the R `sf` library for example.


