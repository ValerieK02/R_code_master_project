# 1. SETTINGS

# Your original CSV file
input_file <- "/Users/valerie/id.csv"

# Folder where the separate CSV files should be saved
output_folder <- "/Users/valerie/id_separate_csv"

# 2. READ CSV FILE
data <- read.csv(input_file, check.names = FALSE)

# 3. EXTRACT DATE FROM FOLDER COLUMN

# Extract the first 10 characters (DD.MM.YYYY)
data$date <- substr(data$FOLDER, 1, 10)

# 4. CREATE OUTPUT FOLDER
dir.create(output_folder, showWarnings = FALSE,
           recursive = TRUE)

# 5. SPLIT TABLE BY DATE

tables <- split(data, data$date)

# 6. SAVE SEPARATE CSV FILES
for (date in names(tables)) {
  
  # Get rows belonging to this date
  table <- tables[[date]]
  
  # Remove temporary date column
  table$date <- NULL
  
  # Create output file name
  output_file <- file.path(
    output_folder,
    paste0(date, ".csv")
  )
  
  # Save CSV file
  write.csv(table, output_file, row.names = FALSE)
}







# ----------------------------------------
# ----------------------------------------






  
  # 1. IMPORT CSV FILE

# Enter the path to your CSV file
input_file <- "/Users/valerie/id_separate_csv/17.10.2025.csv"

# Read the CSV file
data <- read.csv(input_file, check.names = FALSE)


# 2. COUNT HOW MANY ROWS SAY "XXX" ------------

sum(data[["AUTO ID"]] == "BARBAR", na.rm = TRUE)

# --------------------------------------
# --------------------------------------
  
  # 1. IMPORT CSV FILE ----------------------------

input_file <- "/Users/valerie/id.csv"

data <- read.csv(input_file, check.names = FALSE)


# 2. FILTER ROWS -------------------------------

# Exclude empty cells and specific values

filtered_data <- data[
  !is.na(data[["MANUAL ID*"]]) &
    trimws(data[["MANUAL ID*"]]) != "" &
    !(trimws(data[["MANUAL ID*"]]) %in% c(
      "VERY VERY IMPORTANT",
      "VERY IMPORTANT",
      "IMPORTANT",
      "CHECK AGAIN"
    )),
]


# 3. SAVE NEW CSV FILE

output_file <- "/Users/valerie/id_separate_csv/manual_id_filtered.csv"

write.csv(filtered_data, output_file, row.names = FALSE)


# 4. CHECK RESULTS

# Number of rows in original table
nrow(data)

# Number of rows in filtered table
nrow(filtered_data)











# FIND DUPLICATES IN A TABLE
# Location of your CSV file
input_file <- "/Users/valerie/id.csv"

# Read CSV file
data <- read.csv(input_file, check.names = FALSE)

# Show all names that appear more than once
table(data[["IN FILE"]])[table(data[["IN FILE"]]) > 1]

sum(table(data[["IN FILE"]]) > 1)

# To see which names are duplicated and how often
sort(table(data[["IN FILE"]]), decreasing = TRUE)










# Figure out if duplicated file names are complete identifcal in the entire row
# 1. IMPORT CSV FILE ----------------------------

input_file <- "/Users/valerie/id.csv"

data <- read.csv(input_file, check.names = FALSE)


# 2. FIND DUPLICATED FILE NAMES -----------------

duplicates <- data[
  duplicated(data[["OUT FILE FS"]]) |
    duplicated(data[["OUT FILE FS"]], fromLast = TRUE),
]


# 3. CHECK IF DUPLICATED ROWS ARE IDENTICAL -----

# Count duplicated file names
cat("Duplicated file names:",
    length(unique(duplicates[["OUT FILE FS"]])), "\n")

# Check which files have differences between rows
different <- sapply(
  split(duplicates, duplicates[["OUT FILE FS"]]),
  function(x) nrow(unique(x)) > 1
)

# Show results
cat("Files with identical rows:", sum(!different), "\n")
cat("Files with different rows:", sum(different), "\n")

# Show names of files with differences
names(different)[different]





# 1. IMPORT CSV FILE ----------------------------

input_file <- "/Users/valerie/id.csv"

data <- read.csv(input_file, check.names = FALSE)


# 2. FIND ROWS WITH MISSING FILE NAMES ----------

missing <- is.na(data[["OUT FILE FS"]]) |
  trimws(data[["OUT FILE FS"]]) == ""


# 3. COMPARE ROWS -------------------------------

# Exclude the file name column
columns <- names(data) != "OUT FILE FS"

# Find matches among rows with file names
matches <- duplicated(
  rbind(data[missing, columns],
        data[!missing, columns]),
  fromLast = TRUE
)

# Keep only results for the 33 missing-name rows
matches <- matches[seq_len(sum(missing))]


# 4. SHOW RESULTS -------------------------------

cat("Rows with missing file names:", sum(missing), "\n")
cat("Rows matching another file:", sum(matches), "\n")
cat("Rows without a match:", sum(!matches), "\n")




# Check number of WAV files in folder
# 1. SELECT INPUT FOLDER ------------------------

input_folder <- "/Users/valerie/17.10.2025_CM-14/Data"

# 2. COUNT ALL FILES ----------------------------

all_files <- list.files(input_folder)

cat("Total files:", length(all_files), "\n")


# 3. COUNT WAV FILES ----------------------------

wav_files <- list.files(
  input_folder,
  pattern = "\\.wav$",
  ignore.case = TRUE
)

cat("WAV files:", length(wav_files), "\n")


# 4. COUNT NON-WAV FILES ------------------------

cat("Non-WAV files:",
    length(all_files) - length(wav_files), "\n")







#Check for WAV file length

# Install tuneR if necessary
install.packages("tuneR")
library(tuneR)

# 1. INPUT FOLDER -------------------------------

input_folder <- "/Users/valerie/17.10.2025_CM-14/Data"

# 2. FIND WAV FILES -----------------------------

files <- list.files(
  input_folder,
  pattern = "\\.wav$",
  full.names = TRUE,
  ignore.case = TRUE
)

# 3. CHECK RECORDING DURATIONS ------------------

durations <- sapply(files, function(f) {
  tryCatch({
    info <- readWave(f, header = TRUE)
    info$samples / info$sample.rate
  }, error = function(e) NA_real_)
})

# 4. SHOW RESULTS -------------------------------

cat("Total WAV files:", length(files), "\n")
cat("Files shorter than 1 second:", sum(durations < 1, na.rm = TRUE), "\n")
cat("Files shorter than 0.5 seconds:", sum(durations < 0.5, na.rm = TRUE), "\n")
cat("Unreadable WAV headers:", sum(is.na(durations)), "\n")




# Check if BD2 hat problems finding the right wav files because of a difference in labeling
# Count WAV files by extension

all_files <- list.files(input_folder)

cat("Files ending in .wav:",
    sum(grepl("\\.wav$", all_files)), "\n")

cat("Files ending in .WAV:",
    sum(grepl("\\.WAV$", all_files)), "\n")

