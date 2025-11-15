# 📝 Movie Review Text Mining & Sentiment Analysis (R)

![R](https://img.shields.io/badge/Built%20With-R-blue?logo=r)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 🎬 Overview

This project applies **Text Mining and Sentiment Analysis in R** to explore movie reviews. It uses both traditional (`tm`) and modern (`tidytext`) NLP techniques to uncover themes, sentiments, frequent words, and emotional tones within the text.

---

## ✅ Features

- 🧹 **Text Cleaning** – Stopwords, punctuation, numbers, whitespace  
- 📚 **Document-Term Matrix (DTM)**  
- 📊 **Word Frequency & Correlation Analysis**  
- ☁️ **Word Cloud Generation**  
- 💬 **Sentiment Analysis (NRC Emotion Lexicon)**  
- 📈 **ggplot2 Visualizations**  
- ♻️ **Modular & Reproducible Code**

---

## 📊 Key Results

| Insight | Result |
|---------|--------|
| **Most Frequent Word** | *film* (24 times) |
| **Positive vs Negative Words** | 194 vs 156 |
| **Top Emotions** | Trust, Joy, Fear |
| **Associated Words with "film"** | hell, comic, novel, graphic |
| **Common Words (>3 freq.)** | film, like, make, movie, good |

---

## ☁️ Word Cloud

<img width="558" height="753" alt="image" src="https://github.com/user-attachments/assets/2686975d-83e6-401c-b274-e59fd2d4f3a3" />


```r
wordcloud(words = names(freq_terms),
          freq = freq_terms,
          min.freq = 4,
          random.order = FALSE,
          colors = brewer.pal(8, "Dark2"))
```

---

## ✅ Getting Started Checklist

| Task | Status |
|------|--------|
| ☐ Install R & RStudio |
| ☐ Clone this repository |
| ☐ Place `Textdata.txt` in `data/raw/` |
| ☐ Run `outputs/Installation_Commands.R` |
| ☐ Set working directory in RStudio |
| ☐ Run `notebook/Movie_Review_Text_Analysis.R` |
| ☐ (Optional) Run `outputs/Quick_Start_Guide.R` |
| ☐ View word cloud, sentiment, frequency plots |

---

## 📂 Project Structure

```
├── data/raw/                      # Movie reviews (.txt)
├── notebook/                     # Full analysis script
├── outputs/                      # Guides, word clouds, sentiment plots
├── R/                            # Custom functions (optional)
└── TMNLP_movie_review.Rproj      # RStudio project file
```

---

## ⚙️ How to Run

```r
source("outputs/Installation_Commands.R")  # Install packages
setwd("path/to/project")                   # Set working directory
source("notebook/Movie_Review_Text_Analysis.R")  # Full run
source("outputs/Quick_Start_Guide.R")             # Quick version
```

---

## 🛠 Tools

- **R (tm, tidytext, dplyr, ggplot2, wordcloud)**  
- **RStudio**  
- **GitHub for version control**

---

## 📞 Contact

Developed by **Business Enterprise Data Architecture (BEDA)**  
📧 Email: wphiri@beda.ie  
🔗 LinkedIn: [William Phiri](https://www.linkedin.com/in/william-phiri-866b8443/)  
💡 *"Get it done the BEDA way"*

---

## 📄 License

This project is licensed under the **MIT License**. See the LICENSE file for details.

---

## 🏷 Tags

`text-mining` `nlp` `sentiment-analysis` `r-programming` `movie-reviews` `tidytext` `tm` `data-visualization`
