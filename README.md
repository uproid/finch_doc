# 📚 Finch Documentation Website

> **A beautiful documentation platform built with Finch, showcasing how to use Finch to display Markdown documentation**

Welcome! This is the official documentation website for **Finch** - a powerful web framework for Dart. What makes it special? This documentation platform is built using Finch itself! It's a perfect example of Finch's capabilities in creating elegant, functional web applications.

[![GitHub](https://img.shields.io/badge/GitHub-uproid%2Ffinch__doc-blue?logo=github)](https://github.com/uproid/finch_doc)

## ✨ What is This?

This project serves two purposes:

1. **A Documentation Platform**: A clean, user-friendly environment for displaying Markdown documentation
2. **A Real-World Example**: Demonstrates Finch's powerful features by using it to document itself (how meta! 🎭)

Think of it as a documentation viewer that's both the teacher and the student - it teaches you about Finch while being built with Finch!

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed on your system
- OR Dart SDK (if you prefer running without Docker)

### Running with Docker (Recommended)

The easiest way to get started:

```bash
docker compose up --build
```

That's it! Open your browser and navigate to `http://localhost:9902` to view the documentation.

### Running without Docker

If you prefer to run it directly with Dart:

1. Install dependencies:
```bash
dart pub get
```

2. Run the application:
```bash
dart run lib/app.dart
```

3. Visit `http://localhost:9902` in your browser

## 📝 Adding Your Own Documentation

Want to add or modify documentation? It's super simple!

1. **Navigate to the `content` folder** - This is where all your Markdown files live
2. **Create or edit `.md` files** - Write your documentation in standard Markdown format
3. **Restart the application** - Your changes will be reflected automatically

### Structure Example

```
content/
  ├── README.md                    # Main documentation index
  ├── 1.install_femch.md          # Installation guide
  ├── 2.finch_cli.md              # CLI documentation
  └── ...                          # Your custom docs here!
```

**Pro tip**: Follow the numbering convention (1., 2., 3., etc.) to maintain a logical order in your documentation.

## 🎨 Features

- **Markdown Support**: Write documentation in familiar Markdown syntax
- **Beautiful UI**: Clean, responsive design built with Twig templates
- **Fast & Lightweight**: Powered by Finch's efficient routing and templating
- **Easy to Customize**: Simple structure makes it easy to theme and extend
- **Docker Ready**: One command deployment with Docker Compose

## 🛠️ Technology Stack

- **Framework**: [Finch](https://github.com/uproid/finch) - A powerful Dart web framework
- **Template Engine**: Twig templates for HTML rendering
- **Styling**: Custom CSS for a clean, modern look
- **Deployment**: Docker & Docker Compose support

## 🤝 Contributing

We'd love your help making this documentation platform even better! Here's how you can contribute:

1. **Fork the repository** on [GitHub](https://github.com/uproid/finch_doc)
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**: Add new features, fix bugs, or improve documentation
4. **Commit your changes**: `git commit -m 'Add some amazing feature'`
5. **Push to the branch**: `git push origin feature/amazing-feature`
6. **Open a Pull Request**: We'll review it as soon as possible!

### Ways to Contribute

- 📖 Improve documentation content
- 🐛 Report bugs or issues
- ✨ Suggest new features
- 🎨 Enhance the UI/UX
- 🌍 Add translations
- 📝 Fix typos or improve clarity

## 📂 Project Structure

```
webapp-doc/
├── content/              # 📝 All your Markdown documentation files
├── lib/
│   ├── app.dart         # 🚀 Application entry point
│   ├── controllers/     # 🎮 Request handlers
│   ├── route/           # 🛣️ URL routing configuration
│   └── widgets/         # 🎨 Twig templates
├── public/              # 🌐 Static assets (CSS, JS, images)
├── docker-compose.yaml  # 🐋 Docker configuration
└── README.md           # 📄 This file!
```

## 📖 Learn More

Want to dive deeper into Finch? Check out:

- [Official Finch Documentation](https://github.com/uproid/finch_doc)
- [Finch Framework Repository](https://github.com/uproid/finch)

## 📜 License

This project is open source and available under the MIT License.

## 💬 Support

Having issues or questions? Feel free to:

- Open an issue on [GitHub](https://github.com/uproid/finch_doc/issues)
- Check out existing documentation in the `content` folder
- Contribute to improving this documentation!

---

**Built with ❤️ using [Finch](https://github.com/uproid/finch)**

*Happy documenting! 📚✨*
