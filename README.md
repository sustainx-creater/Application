

# EZMove Git README 🚀

**EZMove** is a Flutter app for relocating to Ireland, offering housing listings, community features, articles, and a chatbot. This README covers using **Git** to manage the codebase.
[Technical Documentation](https://word.cloud.microsoft/open/onedrive/?docId=9CB24D6CEBEEB7F3%21s8656d34f5a8d4a4d8cdeb6bd8f09b62d&driveId=9cb24d6cebeeb7f3)


## Overview 🌍
EZMove helps tourists, students, and professionals with:
- **Housing**: Browse accommodations (Supabase, CSV).
- **Community**: Group chats, buddy system, events, Q&A.
- **Articles**: Markdown-rendered content.
- **Chatbot**: AI for relocation queries.
- **UI**: Responsive mobile/web with animations.

**Tech**: Flutter (Dart), Supabase (PostgreSQL, Auth, Storage), animate_do, google_fonts, flutter_markdown, lottie.

## Project Structure 📂
```
lib/
├── main.dart          # App entry, Supabase setup
├── home.dart          # Home with navigation
├── signin.dart        # Auth screens
├── housing.dart       # Housing UI
├── community.dart     # Chats, events, Q&A
├── articles.dart      # Article rendering
├── chatbot.dart       # Chatbot UI
├── theme.dart         # Styling
├── csv_reader.dart    # CSV parsing
assets/                # Images, CSV
```

## Git Setup 🛠️
1. **Install Git**:
   - Windows: [git-scm.com](https://git-scm.com).
   - macOS: `brew install git`.
   - Linux: `sudo apt install git`.
   - Verify: `git --version`.
2. **Configure**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
3. **Clone**:
   ```bash
   git clone https://github.com/sustainx-creater/Application.git
   cd Application
   ```
4. **Dependencies**:
   ```bash
   flutter pub get
   ```
5. **Supabase**: Update `supabaseUrl`, `supabaseAnonKey` in `lib/main.dart`.

## Key Git Commands 📋
- **Track**: `git add .`, `git commit -m "Add feature"`
- **Status**: `git status`
- **Branch**: `git checkout -b feature/x`
- **Merge**: `git checkout main`, `git merge feature/x`
- **Remote**: `git push origin feature/x`, `git pull origin main`
- **Undo**: `git restore <file>`, `git commit --amend`

## Workflow 🔄
1. Branch: `git checkout -b feature/chatbot`.
2. Edit, commit: `git add .`, `git commit -m "Add chatbot UI"`.
3. Push: `git push origin feature/chatbot`.
4. Create PR on GitHub.
5. Merge to `main`.

## Best Practices ✅
- Clear commits: `"Fix housing filter bug"`.
- Branch per feature.
- Pull often: `git pull origin main`.
- Use `.gitignore` for `build/`, `.env`.

## Troubleshooting 🐛
- **Conflicts**: Resolve `<<<<<<<` markers, then `git commit`.
- **Push Fails**: `git pull --rebase`, then push.
- **Lost Commits**: `git reflog`.

## Contact 📬
- Email: [teamsustainx@gmail.com](mailto:teamsustainx@gmail.com)
- Website: [https://sustainax.netlify.app/](https://sustainax.netlify.app/)
- GitHub: [sustainx-creater/Application](https://github.com/sustainx-creater/Application)

Code, commit, relocate! 🎉
