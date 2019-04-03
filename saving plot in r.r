# https://ggplot2.tidyverse.org/reference/ggsave.html

# ggplot(aes()) +
# geom_xxx() +
ggsave('name_of_plot', 
         device='png', # "pdf", "jpeg", "tiff", "png", "bmp", "svg", ...
         path='./folder_for_plots', # Adding to current path, folder must exist before saving plot
         width=25, height=15, units='cm', dpi=300) # dpi: "retina" (320), "print" (300), or "screen" (72)
