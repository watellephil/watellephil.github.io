import path from "path"
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/',  // Remplacez par le nom exact de votre repo
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})