import "./scss/style.scss"
import { createApp } from "vue"
import App from "/src/vue/stack/App.vue"

createApp(App).mount("#app")

// Register Service Worker for offline support
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').then(
      (registration) => {
        console.log('ServiceWorker registered:', registration)
      },
      (err) => {
        console.log('ServiceWorker registration failed:', err)
      }
    )
  })
}

