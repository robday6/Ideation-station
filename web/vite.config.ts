import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// Relative base so the build works from GitHub Pages (/ideation-station/web/) or any folder.
export default defineConfig({
  base: './',
  plugins: [react()],
})
