const CACHE_NAME = 'cv-resume-v1'
const urlsToCache = [
  '/',
  '/index.html',
  '/manifest.json',
  '/images/icons/resume.ico',
]

// Install event - cache essential assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(urlsToCache).catch(err => {
        console.warn('Cache addAll error:', err)
        // Continue without caching if it fails
        return Promise.resolve()
      })
    })
  )
  self.skipWaiting()
})

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName)
          }
          return Promise.resolve()
        })
      )
    })
  )
  self.clients.claim()
})

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
  // Skip non-GET requests
  if (event.request.method !== 'GET') {
    return
  }

  // Skip analytics and external scripts
  if (event.request.url.includes('analytics.thexiao77.com') ||
    event.request.url.includes('fonts.googleapis.com') ||
    event.request.url.includes('fonts.gstatic.com')) {
    return
  }

  event.respondWith(
    caches.match(event.request).then((response) => {
      if (response) {
        return response
      }

      return fetch(event.request).then((response) => {
        // Don't cache non-successful responses
        if (!response || response.status !== 200 || response.type === 'error') {
          return response
        }

        // Clone the response
        const responseToCache = response.clone()

        // Cache successful responses for images and assets
        if (event.request.url.includes('/images/') ||
          event.request.url.includes('/webfonts/') ||
          event.request.destination === 'style' ||
          event.request.destination === 'script') {
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseToCache)
          })
        }

        return response
      }).catch(() => {
        // Return a fallback response
        if (event.request.destination === 'image') {
          // Return placeholder image or blank
          return new Response('', { status: 408, statusText: 'Request Timeout' })
        }
        // Return offline page or error response
        return new Response('Offline - Please check your connection', { status: 503, statusText: 'Service Unavailable' })
      })
    })
  )
})
