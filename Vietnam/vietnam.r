library(sf)
library(tidyverse)
library(leaflet)
library(stringi)
library(htmlwidgets)
### import data 
# Vietnam
df <- st_read("Downloads/vnm_admbnda_2018_shp/vnm_admbnda_adm2_2018_v2.shp")
# Orders
df1 <- read_csv("Downloads/district_.csv")
# Transition 
ts <- read_csv("Downloads/raw1.csv")
# Write to shapefile and csv for Tableau purpose
# st_write(df, "Downloads/df.shp", layer_options = "ENCODING=UTF-8", delete_layer = TRUE)
# write_csv(df1, "Downloads/data.csv")

# Joining 
tmp <- merge(x = df, y = ts, by.x = "ADM2_VI", by.y = "df.ADM2_VI")
full <- merge(x = tmp, y = df1, by.x = "Mask", by.y = "district_name")

# Prepare for mapping
## Legend
bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)*10
## Colour
pal <- colorBin("YlOrRd", domain = full$number_sub_mems, bins = bins)
## Label
labels <- sprintf(
  "<strong>%s</strong><br/><strong>%s</strong><br/>%g customers",
  full$ADM1_VI, full$Mask, full$numnber_sub_mems
) %>% lapply(htmltools::HTML)

# Map
map <- leaflet(full) %>%
  addTiles() %>% 
  addPolygons(fillColor = ~pal(numnber_sub_mems),
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 0.7, 
              highlight = highlightOptions(weight = 5,
                                           color = "#666",
                                           dashArray = "",
                                           fillOpacity = 0.7,
                                           bringToFront = TRUE), 
              label = labels,
              labelOptions = labelOptions(style = list("font-weight" = "normal", 
                                                       padding = "3px 8px"),
                                          textsize = "15px",
                                          direction = "auto")
              )%>%
  addLegend(pal = pal, values = ~numnber_sub_mems, opacity = 0.7, 
          title = NULL, position = "bottomright")
# View 
map
# Save
saveWidget(map, file = "map_cus_sub.html")

# Write for Tableau 

st_write(full, "Downloads/full.shp", layer_options = "ENCODING=UTF-8", delete_layer = TRUE)

