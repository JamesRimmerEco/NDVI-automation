####    Script for calculating NDVI rapidly from multiple text files    #####
# Notes: In this present version, there must be NO other files (not even this script) 
# in the working directory other than the files you wish to analyse. When I have
# more time, I will try to fix this so this isn't a requirement.

# You will need to manually set the directory to the directory containing
# your text files. The results from this script are stored in a vector called
# NDVI; write.csv could be used to transform these into a more accessible 
# format for anlysis outwith R. 

################################################################################

# Set up the pathway to the files ensuring the correct file types are extracted (ensure ONLY correct spec files are in the directory)
file_initial <- list.files(path="your directory route HERE",
                           full.names=TRUE, pattern = ".txt")
# Read in each file according to rules which extract the correct data
specfilelist <- lapply(file_initial, read.table, skip = 17, header = F, nrows = 2048)
# Establish the data files as a list format
names(specfilelist) <- list.files(path="your directory route HERE",
                                  full.names=FALSE)
# View(specfilelist)
# Rename the columns for clarity
colnames <- c("Wavelength", "Value")
# Apply to all elements of list
for (i in seq_along(specfilelist)){
  colnames(specfilelist[[i]]) <- colnames
}

### Calculate VIS for all files as an average over wavelengths 673 to 677 nm
VIS_range <- lapply(specfilelist,"[", 940:951, 2)
VIS <- lapply(VIS_range, mean)
### Calculate NIR for all files as an average over wavelengths 748 and 752 nm
NIR_range <- lapply(specfilelist,"[", 1163:1174, 2)
NIR <- lapply(NIR_range, mean)
# Calculate NDVI
NDVI <- vector(length = length(NIR))
for(i in 1:length(NIR)){
  NDVI[i] <- (NIR[[i]]-VIS[[i]])/(NIR[[i]] + VIS[[i]])
}

NDVI
