import { defineConfig } from 'vite'

export default defineConfig({
  base: '/watellephil.github.io/',  // ← IMPORTANT : remplacez par le nom exact de votre dépôt GitHub
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  }
})