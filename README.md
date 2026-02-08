# POV
📍 POV

Landmark Lens is a mobile application that uses Google Gemini 3 to identify landmarks from photos and provide personalized, interactive travel insights. Users can scan real-world locations and instantly learn about history, culture, and fun facts through AI-powered analysis.

This project was developed for the Google Gemini 3 Hackathon.

🚀 Features

📷 Photo-Based Landmark Recognition

Identify landmarks using images from camera or gallery.

🧠 AI-Powered Analysis (Gemini 3)

Multimodal understanding (image + context)

Structured JSON responses

Confidence scoring and uncertainty handling

🎯 Personalized Learning

Adapts explanations based on user age and interests

📊 Journey Tracking

View past scans and exploration history

Track number of landmarks visited

📱 Cross-Platform Mobile App

Built with Flutter (Android / iOS / Desktop supported)

🛠️ Tech Stack
Frontend

Flutter (Dart)

Material 3 UI

Image Picker

HTTP Client

Backend

FastAPI (Python)

Google Gemini 3 API

Supabase (Database)

Uvicorn (Server)

AI / ML

Google Gemini 3 Multimodal Models

Structured JSON Output

Personalized Prompting

📂 Project Structure
Landmark-Lens/
│
├── backend/
│   ├── db/
│   ├── routes/
│   ├── schemas/
│   ├── services/
│   └── main.py
│
├── frontend/
│   ├── lib/
│   │   ├── screens/
│   │   ├── services/
│   │   └── main.dart
│   └── pubspec.yaml
│
└── README.md

⚙️ Setup Instructions
1️⃣ Clone Repository
git clone https://github.com/your-username/Landmark-Lens.git
cd Landmark-Lens


🔧 TODO: Replace your-username with actual repo owner.

2️⃣ Backend Setup
Install Dependencies
cd backend
pip install -r requirements.txt


🔧 TODO: Create requirements.txt if missing.

Set Environment Variables

Create a .env file:

GEMINI_API_KEY=your_api_key_here
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key


🔧 TODO: Replace with real credentials.

Run Backend Server
python main.py


Backend runs at:

http://localhost:8000

3️⃣ Frontend Setup
Install Flutter Packages
cd frontend
flutter pub get

Run App
flutter run

🔗 API Endpoints
Identify Landmark
POST /identify/


Form Data:

Field	Type	Description
image	File	Image file
user_id	String	User ID
age_bracket	String	Optional
interests	String	Optional
lat	Float	Latitude
lng	Float	Longitude

Response:

Returns structured landmark data in JSON format.

🧩 Gemini Integration

We use Gemini 3 for:

Multimodal image understanding

Landmark identification

Context-aware reasoning

Personalized explanations

Schema-based JSON generation

Gemini processes:

Image input

User profile

System instructions

In a single request using long-context reasoning.

📖 Usage Guide

Open the app

Tap the camera or gallery button

Select an image

Wait for AI analysis

View landmark details

Explore history and fun facts

Check journey history

🎥 Demo

🔧 TODO: Add demo video link (YouTube/Vimeo)

Example:

https://youtu.be/your-demo-video

🌍 Hackathon Submission

This project was submitted to:

Google Gemini 3 Hackathon (2025–2026)

Submission includes:

Working application

Public repository

Demo video

Gemini integration write-up

🧪 Testing

🔧 TODO: Add automated tests (if available)

Current testing:

Manual UI testing

API response validation

Error handling checks

👥 Team
Name	Role
[Your Name]	Frontend / Backend / AI
[Teammate]	Backend / UI
[Teammate]	Design / Research

🔧 TODO: Update team members.

📜 License

🔧 TODO: Choose a license (MIT / Apache / GPL)

Example:

MIT License

📬 Contact

For questions:

📧 Email: your-email@example.com

🌐 GitHub: https://github.com/your-username

🔧 TODO: Update contact info.
