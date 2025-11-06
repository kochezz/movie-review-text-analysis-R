################################################################################
# MOVIE REVIEW TEXT ANALYSIS - R T
# Text mining and sentiment analysis
################################################################################

# ==============================================================================
# STEP 0: INSTALL AND LOAD REQUIRED PACKAGES
# ==============================================================================


install.packages("tm")           # Text Mining package
install.packages("wordcloud")    # For creating word clouds
install.packages("RColorBrewer") # Color palettes for visualizations
install.packages("tidytext")     # Tidy text mining
install.packages("dplyr")        # Data manipulation
install.packages("ggplot2")      # Plotting
install.packages("textdata")     # For sentiment lexicons
install.packages("tidyr")        # Data tidying

# Load the libraries
library(tm)              # Core text mining functions
library(wordcloud)       # Word cloud creation
library(RColorBrewer)    # Color palettes
library(tidytext)        # Tidy approach to text mining
library(dplyr)           # Data manipulation (pipes, filter, etc.)
library(ggplot2)         # Plotting
library(tidyr)           # Unnesting and tidying data

# ==============================================================================
# QUESTION 1: IMPORT AND CLEAN THE DATA
# ==============================================================================
cat("\n=== QUESTION 1: Importing and Cleaning Data ===\n")

# Set your working directory to where your file is located
# Replace this path with your actual file location
# setwd("C:/Your/Path/Here")

# Read the text file
# Method 1: Read as character vector (each line is an element)
text_data <- readLines("Textdata.txt", warn = FALSE)

# View first few lines
cat("First 3 lines of raw data:\n")
print(head(text_data, 3))
cat("\nTotal number of lines:", length(text_data), "\n")

# Create a Corpus (collection of text documents)
# A Corpus is the main structure used by the 'tm' package
corpus <- Corpus(VectorSource(text_data))

cat("\nCorpus created with", length(corpus), "documents\n")

# DATA CLEANING - Essential preprocessing steps
# These transformations prepare the text for analysis

# 1. Convert to lowercase (so "Film" and "film" are treated the same)
corpus <- tm_map(corpus, content_transformer(tolower))
cat("✓ Converted to lowercase\n")

# 2. Remove numbers (usually not meaningful in text analysis)
corpus <- tm_map(corpus, removeNumbers)
cat("✓ Removed numbers\n")

# 3. Remove punctuation marks
corpus <- tm_map(corpus, removePunctuation)
cat("✓ Removed punctuation\n")

# 4. Remove common English stop words (the, is, at, which, etc.)
# These are frequent but usually don't carry much meaning
corpus <- tm_map(corpus, removeWords, stopwords("english"))
cat("✓ Removed stop words\n")

# 5. Remove extra whitespace
corpus <- tm_map(corpus, stripWhitespace)
cat("✓ Removed extra whitespace\n")

# Optional: Stemming (reduces words to their root form)
# e.g., "running", "runs", "ran" all become "run"
# Uncomment the line below if you want to use stemming
# corpus <- tm_map(corpus, stemDocument)

# View a sample of cleaned text
cat("\nSample of cleaned text:\n")
print(as.character(corpus[[1]])[1:200])  # First 200 characters of first document

# ==============================================================================
# CREATE DOCUMENT-TERM MATRIX (DTM)
# ==============================================================================
# A DTM is a matrix where:
# - Rows represent documents (lines in our case)
# - Columns represent terms (unique words)
# - Values represent frequency of each term in each document

dtm <- DocumentTermMatrix(corpus)
cat("\n\nDocument-Term Matrix created:\n")
cat("  Documents (lines):", nrow(dtm), "\n")
cat("  Terms (unique words):", ncol(dtm), "\n")
cat("  Sparsity:", round(100 * (1 - length(dtm$v)/(nrow(dtm)*ncol(dtm))), 2), "%\n")

# ==============================================================================
# QUESTION 2: FIND WORDS WITH MINIMUM FREQUENCY 6
# ==============================================================================
cat("\n\n=== QUESTION 2: Words with Minimum Frequency 6 ===\n")

# Calculate the frequency of each term across all documents
term_freq <- colSums(as.matrix(dtm))

# Sort in decreasing order
term_freq_sorted <- sort(term_freq, decreasing = TRUE)

# Filter words that appear at least 6 times
freq_6 <- term_freq_sorted[term_freq_sorted >= 6]

cat("Words appearing at least 6 times:\n")
print(freq_6)
cat("\nTotal number of words with frequency >= 6:", length(freq_6), "\n")

# You can also visualize this
barplot(freq_6, 
        las = 2,  # Make labels perpendicular
        col = "steelblue",
        main = "Words with Frequency >= 6",
        ylab = "Frequency",
        cex.names = 0.7)  # Make text smaller to fit

# ==============================================================================
# QUESTION 3: WORDS WITH AT LEAST 0.35 CORRELATION WITH 'FILM'
# ==============================================================================
cat("\n\n=== QUESTION 3: Words Correlated with 'film' (>= 0.35) ===\n")

# Find associations (correlations) with the word "film"
# This shows which words tend to appear together with "film"
# Correlation ranges from 0 (no relationship) to 1 (perfect correlation)

# First, check if "film" exists in our DTM
if ("film" %in% colnames(dtm)) {
  film_correlations <- findAssocs(dtm, "film", corlimit = 0.35)
  
  cat("Words with correlation >= 0.35 with 'film':\n")
  print(film_correlations)
  
  # If you want to see the actual correlation values in a cleaner format:
  if (length(film_correlations$film) > 0) {
    corr_df <- data.frame(
      word = names(film_correlations$film),
      correlation = as.numeric(film_correlations$film)
    )
    print(corr_df)
    
    # Visualize correlations
    barplot(corr_df$correlation,
            names.arg = corr_df$word,
            las = 2,
            col = "coral",
            main = "Words Correlated with 'film' (>= 0.35)",
            ylab = "Correlation",
            ylim = c(0, 1),
            cex.names = 0.8)
  } else {
    cat("No words found with correlation >= 0.35 with 'film'\n")
    cat("Try a lower threshold, e.g., 0.25\n")
  }
} else {
  cat("The word 'film' does not appear in the corpus after cleaning.\n")
}

# ==============================================================================
# QUESTION 4: CREATE WORDCLOUD (Minimum Frequency 4)
# ==============================================================================
cat("\n\n=== QUESTION 4: Creating Word Cloud ===\n")

# Calculate term frequencies
term_freq <- colSums(as.matrix(dtm))

# Filter words with frequency >= 4
freq_4 <- term_freq[term_freq >= 4]

# Choose a color palette from RColorBrewer
# View all available palettes: display.brewer.all()
# Popular choices: "Dark2", "Set1", "Paired", "Spectral", "Blues", etc.

cat("Creating word cloud with", length(freq_4), "words (frequency >= 4)\n")

# Set up the plotting window
par(mfrow = c(1, 1))

# Create the word cloud
set.seed(123)  # For reproducibility
wordcloud(words = names(freq_4),
          freq = freq_4,
          min.freq = 4,
          max.words = 100,  # Maximum number of words to display
          random.order = FALSE,  # Plot words in frequency order
          rot.per = 0.35,  # Proportion of words at 90 degrees
          colors = brewer.pal(8, "Dark2"),  # Color palette
          scale = c(3.5, 0.5))  # Size range of words

title(main = "Word Cloud (Min Frequency = 4)", 
      cex.main = 1.5)

cat("✓ Word cloud created successfully!\n")

# ==============================================================================
# QUESTION 5: SENTIMENT ANALYSIS
# ==============================================================================
cat("\n\n=== QUESTION 5: Sentiment Analysis ===\n")

# For sentiment analysis, we'll use the NRC emotion lexicon
# This lexicon associates words with 8 emotions + positive/negative

# First, create a tidy data frame from our original text
text_df <- data.frame(
  line = 1:length(text_data),
  text = text_data,
  stringsAsFactors = FALSE
)

# Unnest the text into individual words (tokens)
# This creates one row per word
tidy_text <- text_df %>%
  unnest_tokens(word, text)

cat("Total words in tidy format:", nrow(tidy_text), "\n")

# Load the NRC lexicon (contains emotions and sentiments)
# You may need to download it the first time
# Just confirm "yes" if prompted
nrc <- get_sentiments("nrc")

cat("NRC lexicon loaded with", nrow(nrc), "word-sentiment pairs\n")

# Join our text with the sentiment lexicon
sentiment_analysis <- tidy_text %>%
  inner_join(nrc, by = "word")

# View unique sentiments available
cat("\nAvailable sentiments in NRC:\n")
print(unique(sentiment_analysis$sentiment))

# Note: The NRC lexicon doesn't have "Sarcasm", "Very Negative", or "Very Positive"
# It has: anger, anticipation, disgust, fear, joy, sadness, surprise, trust,
#         negative, positive

# Count lines by sentiment
sentiment_by_line <- sentiment_analysis %>%
  group_by(line, sentiment) %>%
  summarise(count = n(), .groups = 'drop')

# For the specific sentiments requested, we'll use what's available:
# - "Very Negative" → we'll interpret as "negative" + specific negative emotions
# - "Very Positive" → we'll interpret as "positive" + specific positive emotions
# - "Sarcasm" → unfortunately, NRC doesn't detect sarcasm

# Count lines with different sentiments
lines_negative <- sentiment_by_line %>%
  filter(sentiment == "negative") %>%
  distinct(line) %>%
  nrow()

lines_positive <- sentiment_by_line %>%
  filter(sentiment == "positive") %>%
  distinct(line) %>%
  nrow()

# We can also look at specific negative emotions (anger, disgust, fear, sadness)
lines_very_negative <- sentiment_by_line %>%
  filter(sentiment %in% c("anger", "disgust", "fear", "sadness")) %>%
  distinct(line) %>%
  nrow()

# And positive emotions (joy, trust, anticipation)
lines_very_positive <- sentiment_by_line %>%
  filter(sentiment %in% c("joy", "trust", "anticipation")) %>%
  distinct(line) %>%
  nrow()

cat("\n=== SENTIMENT COUNTS BY LINE ===\n")
cat("Lines with NEGATIVE sentiment:", lines_negative, "\n")
cat("Lines with POSITIVE sentiment:", lines_positive, "\n")
cat("Lines with strong negative emotions (anger/disgust/fear/sadness):", 
    lines_very_negative, "\n")
cat("Lines with strong positive emotions (joy/trust/anticipation):", 
    lines_very_positive, "\n")
cat("\nNote: NRC lexicon doesn't detect 'Sarcasm' directly\n")
cat("      Sarcasm detection requires more advanced NLP techniques\n")

# Overall sentiment distribution
sentiment_counts <- sentiment_analysis %>%
  count(sentiment, sort = TRUE)

cat("\n=== OVERALL SENTIMENT DISTRIBUTION ===\n")
print(sentiment_counts)

# Visualize sentiment distribution
ggplot(sentiment_counts, aes(x = reorder(sentiment, n), y = n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Sentiment Distribution in Movie Reviews",
       x = "Sentiment",
       y = "Count") +
  theme_minimal() +
  theme(legend.position = "none")

# ==============================================================================
# QUESTION 6: PLOT WORDS OCCURRING MORE THAN 3 TIMES (using tidytext)
# ==============================================================================
cat("\n\n=== QUESTION 6: Words Occurring More Than 3 Times ===\n")

# Count word frequencies using tidy approach
word_counts <- tidy_text %>%
  count(word, sort = TRUE)

# Filter words appearing more than 3 times
frequent_words <- word_counts %>%
  filter(n > 3)

cat("Number of words occurring more than 3 times:", nrow(frequent_words), "\n")
print(head(frequent_words, 15))

# Create a bar plot
ggplot(frequent_words, aes(x = reorder(word, n), y = n, fill = n)) +
  geom_bar(stat = "identity") +
  coord_flip() +  # Horizontal bars for better readability
  labs(title = "Words Occurring More Than 3 Times",
       x = "Word",
       y = "Frequency") +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.y = element_text(size = 10))

# Alternative visualization: with word labels
ggplot(frequent_words %>% top_n(20, n), 
       aes(x = reorder(word, n), y = n)) +
  geom_segment(aes(x = reorder(word, n), 
                   xend = reorder(word, n), 
                   y = 0, 
                   yend = n), 
               color = "steelblue", 
               size = 1) +
  geom_point(size = 3, color = "darkblue") +
  coord_flip() +
  labs(title = "Top 20 Most Frequent Words (Count > 3)",
       x = "Word",
       y = "Frequency") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 10))

cat("\n✓ All analyses completed successfully!\n")

# ==============================================================================
# SUMMARY AND ADDITIONAL TIPS
# ==============================================================================
cat("\n" , rep("=", 80), "\n", sep = "")
cat("TUTORIAL COMPLETE!\n")
cat(rep("=", 80), "\n\n", sep = "")

cat("KEY LEARNINGS:\n")
cat("1. Text preprocessing: lowercase, remove punctuation, remove stopwords\n")
cat("2. Document-Term Matrix: represents word frequencies across documents\n")
cat("3. findAssocs(): finds words that co-occur with a target word\n")
cat("4. wordcloud: visual representation of word frequencies\n")
cat("5. Sentiment analysis: using lexicons to detect emotions in text\n")
cat("6. tidytext: modern approach to text mining with dplyr-style operations\n")

cat("\nADDITIONAL TIPS:\n")
cat("• Try different color palettes: display.brewer.all()\n")
cat("• Experiment with different correlation thresholds\n")
cat("• Use stemDocument() for more aggressive text normalization\n")
cat("• Try other sentiment lexicons: 'bing', 'afinn', 'loughran'\n")
cat("• For bigrams/trigrams, use unnest_tokens(word, text, token = 'ngrams', n = 2)\n")

cat("\n📊 Remember to save your plots using ggsave() or the RStudio Export button!\n")