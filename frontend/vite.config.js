import yaml from '@rollup/plugin-yaml'
import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

// https://vitejs.dev/config/
export default defineConfig({
    base: '/vue-resume-template/',
    plugins: [
        vue(),
        yaml()
    ],
    css: {
        preprocessorOptions: {
            scss: {
                silenceDeprecations: ["color-functions", "global-builtin", "import"],
            },
        },
    }
})
