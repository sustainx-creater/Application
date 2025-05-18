

# Git README 🚀

Welcome to your project's version control setup with **Git**! This README covers the essentials to get you started with Git for tracking changes, collaborating, and keeping your codebase organized.
[Technical Documentation](https://word.cloud.microsoft/open/onedrive/?docId=9CB24D6CEBEEB7F3%21s8656d34f5a8d4a4d8cdeb6bd8f09b62d&driveId=9cb24d6cebeeb7f3)

## What is Git? 🤔
Git is a fast, distributed version control system that lets you:
- Track code changes with snapshots (commits).
- Work on multiple features using branches.
- Collaborate seamlessly with teams via remote repositories (e.g., GitHub, GitLab).

## Getting Started 🛠️

### Installation
1. **Install Git**:
   - Windows: Download from [git-scm.com](https://git-scm.com).
   - macOS: `brew install git` (with Homebrew).
   - Linux: `sudo apt install git` (Debian/Ubuntu) or `sudo yum install git` (CentOS).
2. Verify: `git --version`.
3. Configure:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

### Project Setup
1. **Initialize a Repository**:
   ```bash
   git init
   ```
2. **Clone an Existing Repo**:
   ```bash
   git clone <repository-url>
   ```

## Key Commands 📋
### Basic Workflow
- Check status: `git status`
- Stage files: `git add <file>` or `git add .`
- Commit changes: `git commit -m "Add feature X"`
- View history: `git log --oneline`

### Branching
- Create branch: `git branch feature-x`
- Switch branch: `git checkout feature-x`
- Create & switch: `git checkout -b feature-x`
- Merge: `git merge feature-x`

### Remote Collaboration
- Add remote: `git remote add origin <url>`
- Push: `git push origin main`
- Pull: `git pull origin main`

### Undo Changes
- Discard changes: `git restore <file>`
- Unstage: `git restore --staged <file>`
- Amend commit: `git commit --amend`

## Project Workflow 🔄
1. Create a branch for your feature: `git checkout -b feature/login`.
2. Make changes, stage, and commit: `git add . && git commit -m "Add login UI"`.
3. Push to remote: `git push origin feature/login`.
4. Create a pull request (PR) on your platform (e.g., GitHub).
5. Merge into `main` after review.

## Best Practices ✅
- Write clear commit messages (e.g., "Fix bug in auth flow").
- Use branches for every feature or fix.
- Pull regularly to avoid conflicts.
- Add a `.gitignore` file for files like `node_modules/` or `.env`.

## Troubleshooting ⚙️
- **Merge Conflict**: Edit conflicting files, resolve markers, then `git commit`.
- **Push Rejected**: Run `git pull --rebase`, resolve conflicts, then push.
- **Lost Commits**: Use `git reflog` to recover.

## Resources 📚
- [Official Git Docs](https://git-scm.com/doc)
- [Git Cheat Sheet](https://github.github.io/training-kit/downloads/github-git-cheat-sheet.pdf)
- Search `#git` on X for community tips.

## Need Help? 📬
- Email: [git@git-scm.com](mailto:git@git-scm.com)
- Website: [git-scm.com](https://git-scm.com)

Happy coding and version controlling! 🎉
