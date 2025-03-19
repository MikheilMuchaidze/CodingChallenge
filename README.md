# 📚 Table of Contents Viewer

A SwiftUI-based iOS app that displays a structured **Table of Contents** with hierarchical sections and interactive questions. The app adapts font sizes based on content hierarchy, supports image-based questions, and includes offline caching for a seamless user experience.


---

## 🚀 Features

### 📌 **Content Hierarchy & Font Sizes**
- **Pages** → Largest font size.
- **Sections** → Medium font size, decreasing for nested sections.
- **Questions** → Smallest font size.

### 🖼️ **Image Handling**
- For text-based questions, the text is displayed directly.
- For image-based questions:
  - Images are **fetched and displayed in a reduced size**.
  - **Tapping an image** opens a new screen to view it **full-size** with its title.

  ---

## 🛠 **Functionalities**  

### **🔄 Refresh Button (Top Left)**
- Triggers **manual data refresh** by fetching content from the server again.

### **🗑️ Remove Cache Button (Top Right)**
- Clears cached data from **UserDefaults** and the **ViewModel**.
- If **no cache exists**, this button is disabled.
- Shows an **alert confirmation** when pressed to notify the user about the action.

### **🚨 Error Mode (Second from Left)**
- **Toggles "Error Mode"**, where all fetch requests **intentionally return an error** for testing failure handling.

### **🛑 Error Handling**
When an error occurs, an **alert** is displayed with the following options:
1. **Retry** – Attempts to fetch data again.
2. **Read from Cache** – Loads previously fetched data from **UserDefaults** (Only if cache exists).
3. **Cancel** – Dismisses the alert.

- If **no cache exists**, the "Read from Cache" button is **not displayed**.


### 🌍 **Offline Support & Network Handling**
- 📡 **Offline Support**: Previously fetched data is stored locally for viewing without an internet connection.
- ❌ **Network Failure Handling**: Displays an error message when the internet is unavailable and falls back to cached data.

---

## 🛠 **Tech Stack**
- **SwiftUI** for the user interface.
- **Combine & Async/Await** for efficient data fetching.
- **URLSession** for API calls.
- **UserDefaults** for offline data caching.

---

## 📦 **Installation**
1. Clone this repository:
   ```bash
   git clone https://github.com/MikheilMuchaidze/CodingChallenge.git
2. Run project

