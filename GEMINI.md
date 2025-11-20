# GEMINI.md: Project Overview for watellephil.github.io

This document provides a comprehensive overview of the `watellephil.github.io` project, intended for AI assistants and developers to understand its structure, purpose, and development conventions.

## Project Overview

This project is a modern, single-page personal portfolio website for Philémon Watelle. It is built using a robust and current web development stack, focusing on a clean user interface and component-based architecture. The site is automatically deployed to GitHub Pages.

**Key Technologies:**

*   **Framework:** React
*   **Build Tool:** Vite
*   **Language:** TypeScript
*   **UI Components:** shadcn/ui on top of Radix UI
*   **Styling:** Tailwind CSS
*   **Routing:** React Router DOM
*   **Deployment:** GitHub Actions to GitHub Pages

**Architecture:**

The application is structured as a main single-page layout (`pages/Index.tsx`) which is composed of several distinct, reusable React components found in `src/components/`. Each component represents a major section of the portfolio, such as "About", "Skills", and "Projects".

The site also includes additional, separate pages for specific content, such as `/velo` and `/projet-a`.

## Building and Running

The project uses `npm` as its package manager. The following commands are essential for development and deployment.

**1. Install Dependencies:**
First, install the necessary Node.js modules.
```bash
npm install
```

**2. Run Development Server:**
To start the Vite development server with hot-reloading. The site will typically be available at `http://localhost:5173`.
```bash
npm run dev
```

**3. Create a Production Build:**
To build the static files for production. The output is placed in the `dist/` directory.
```bash
npm run build
```

**4. Preview the Production Build:**
To serve the `dist/` directory locally and preview the final production version of the site.
```bash
npm run preview
```

## Development Conventions

*   **Linting:** The project uses ESLint for code quality and consistency. To run the linter, use:
    ```bash
    npm run lint
    ```
*   **Component Structure:** The UI is built with `shadcn/ui`, which means new components are typically added via its CLI, and custom components are built following the patterns in `src/components/`.
*   **Styling:** Utility-first styling is managed with Tailwind CSS. Custom styles should be kept to a minimum and follow Tailwind's configuration (`tailwind.config.ts`).
*   **Deployment:** The site is deployed automatically by a GitHub Actions workflow (`.github/workflows/deploy.yml`) on every push to the `main` branch. Manual deployments are not necessary.
*   **Routing:** New pages should be added to the `src/pages/` directory and registered as a new `<Route>` in `src/App.tsx`.
