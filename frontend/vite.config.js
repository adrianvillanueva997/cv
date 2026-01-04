import yaml from '@rollup/plugin-yaml'
import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'
import { ViteImageOptimizer } from 'vite-plugin-image-optimizer'
import { robots } from 'vite-plugin-robots'
import Sitemap from 'vite-plugin-sitemap'
import compression from 'vite-plugin-compression'

// https://vitejs.dev/config/
export default defineConfig({
    base: '/',
    plugins: [
        vue(),
        yaml(),
        ViteImageOptimizer(),
        robots(),
        Sitemap({ hostname: 'https://resume.adrianvillanueva.com' }),
        compression({
            verbose: true,
            disable: false,
            threshold: 1024,
            algorithm: 'gzip',
            ext: '.gz',
        }),
    ],
    build: {
        rollupOptions: {
            output: {
                manualChunks: {
                    'vendor': ['vue', 'vue-router'],
                    'bootstrap': ['bootstrap', '@popperjs/core'],
                    'charts': ['chart.js', 'vue-chartjs'],
                    'swiper': ['swiper'],
                }
            }
        },
        minify: 'terser',
        sourcemap: false,
    },
    css: {
        preprocessorOptions: {
            scss: {
                silenceDeprecations: ["color-functions", "global-builtin", "import"],
            },
        },
    }
})
