

# get libraries
library(tidyverse);library(magrittr)


WORK_DIR <- "/data/users/skeane/CancerGenomicsProject"
output_dir <- file.path(WORK_DIR, "output")
#------------------------------------------------------------------------------
# Formatting
#------------------------------------------------------------------------------

# VEP output please don't take this script out of script
vep_data <- read.table("../output/vep_clinvar_filtered.txt", 
					   header=F, 
					   sep="\t", 
					   comment.char="#")

# The standard VEP column names are:
colNames <- c("#Uploaded_variation", "Location", "Allele", "Gene", "Feature", "Feature_type",
"Consequence", "cDNA_position", "CDS_position", "Protein_position", "Amino_acids",
"Codons", "Existing_variation", "Extra")

colnames(vep_data) <- colNames

# Splitting data between values
consequences_df <- vep_data %>%
  separate_rows(Consequence, sep="&") %>%
  select(Consequence)

# get chromosomes
vep_data <- vep_data %>%
  separate(Location, into = c("chr", "position"), sep=":") %>% 
  mutate(chr = factor(chr, levels = c("chr6", "chr17")))

# Extract IMPACT from Extra column
vep_data$IMPACT <- gsub(".*IMPACT=([^;]+).*", "\\1", vep_data$Extra)

# get nice data out of the df
extract_field <- function(data, field) {
  gsub(paste0(".*", field, "=([^;]+).*"), "\\1", data$Extra)
}

# combine multiple fields
  mutate(
	IMPACT = extract_field(., "IMPACT"),
	SYMBOL = extract_field(., "SYMBOL"),
	VARIANT_CLASS = extract_field(., "VARIANT_CLASS"),
	BIOTYPE = extract_field(., "BIOTYPE")
  )


#------------------------------------------------------------------------------
# R plots
#------------------------------------------------------------------------------

# Plot 1: Consequence distribution
p1 <- ggplot(vep_data, aes(x = Consequence)) +
  geom_bar() +
  coord_flip() +
  theme_minimal()

# Plot 2: Consequence by chromosome
p2 <- p1 +
  facet_grid(~chr)

# Plot 3: Consequence by impact
p3 <- ggplot(
  vep_data,
  aes(x = Consequence, fill = IMPACT)
) +
  geom_bar() +
  coord_flip() +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Plot 4: Impact by chromosome
p4 <- p3 +
  facet_grid(~chr)

# Plot 5: Variant class
p5 <- vep_data %>%
  count(VARIANT_CLASS, sort = TRUE) %>%
  ggplot(aes(x = reorder(VARIANT_CLASS, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  theme_minimal()

# Plot 6: Biotype
p6 <- ggplot(vep_data, aes(x = BIOTYPE)) +
  geom_bar(fill = "steelblue") +
  coord_flip() +
  theme_minimal()

# Save all plots
plots <- list(p1, p2, p3, p4, p5, p6)

plot_names <- c(
  "01_consequence_distribution",
  "02_consequence_by_chromosome",
  "03_consequence_by_impact",
  "04_impact_by_chromosome",
  "05_variant_class",
  "06_biotype_distribution"
)

for (i in seq_along(plots)) {
  ggsave(
    filename = file.path(output_dir, paste0(plot_names[i], ".pdf")),
    plot = plots[[i]],
    width = 9,
    height = 6
  )
}