import yaml from '@rollup/plugin-yaml'
import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'
import { ViteImageOptimizer } from 'vite-plugin-image-optimizer'
import { robots } from 'vite-plugin-robots'
import Sitemap from 'vite-plugin-sitemap'
// https://vitejs.dev/config/
export default defineConfig({
    base: '/',
    plugins: [
        vue(),
        yaml(),
        ViteImageOptimizer(),
        robots(),
        Sitemap({ hostname: 'https://resume.adrianvillanueva.com' })
    ],
    css: {
        preprocessorOptions: {
            scss: {
                silenceDeprecations: ["color-functions", "global-builtin", "import"],
            },
        },
    }
})
