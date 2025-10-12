<template>
    <!-- Loader Wrapper -->
    <div v-if="visible && currentStep"
         id="resume-loader"
         class="resume-loader"
         :class="{
            'resume-loader-tween-in': currentStep === Steps.WILL_ENTER,
            'resume-loader-tween-out': currentStep === Steps.LEAVING
         }">
        <!-- Matrix Background Effect -->
        <canvas ref="matrixCanvas" class="matrix-canvas"></canvas>

        <!-- Particle Container -->
        <canvas ref="particleCanvas" class="particle-canvas"></canvas>

        <!-- Loader Content -->
        <div class="resume-loader-content">
            <div class="logo-container">
                <ImageView src="images/icons/avm-logo.svg"
                           alt="AVM Logo"
                           class="image-view-logo"
                           :class="{
                              'image-view-logo-animated': currentStep >= Steps.ANIMATING_LOGO,
                              'image-view-logo-glitch': shouldGlitch
                           }"
                           @completed="_onLogoLoaded"
                           :spinner-enabled="false"
                           :resolve-path="true"/>
            </div>

            <div class="resume-loader-progress-display"
                 :class="{
                    'resume-loader-progress-display-hidden': currentStep <  Steps.ANIMATING_PROGRESS,
                    'transition-none': currentStep < Steps.ANIMATING_PROGRESS
                 }">
                <p class="loading-message text-2" v-html="currentMessage"/>
                <p class="percentage text-2" v-html="`${percentage}%`"/>

                <ProgressBar class="resume-loader-progress-bar"
                             :percentage="percentage"/>
            </div>
        </div>
    </div>
</template>

<script setup>
import { inject, onMounted, onUnmounted, ref, watch } from "vue"
import { useScheduler } from "/src/composables/scheduler.js"
import { useUtils } from "/src/composables/utils.js"
import ImageView from "/src/vue/components/widgets/ImageView.vue"
import ProgressBar from "/src/vue/components/widgets/ProgressBar.vue"

const scheduler = useScheduler()
const utils = useUtils()

const props = defineProps({
    visible: Boolean,
    refreshCount: Number,
    smoothTransitionEnabled: Boolean
})

const Steps = {
    NONE: 0,
    WILL_ENTER: 1,
    ENTERING: 2,
    LOADING_LOGO: 3,
    ANIMATING_LOGO: 4,
    ANIMATING_PROGRESS: 5,
    WAITING_FOR_COMPLETION: 6,
    LEAVING: 7
}

const emit = defineEmits(['ready', 'completed'])

/** @type {{value: Boolean}} */
const canScroll = inject("canScroll")

const schedulerTag = "loader"
const didLoadLogo = ref(false)
const didEmitReady = ref(false)
const currentStep = ref(Steps.NONE)
const percentage = ref(0)
const loadingTime = ref(0)
const loadingTimeAfterRendering = ref(0)
const shouldGlitch = ref(false)

// Canvas refs
const matrixCanvas = ref(null)
const particleCanvas = ref(null)
let matrixAnimationId = null
let particleAnimationId = null

// Loading messages
const loadingMessages = [
    "Initializing data pipeline...",
    "Compiling experience...",
    "Deploying resume...",
    "Syncing with cloud...",
    "Building infrastructure...",
    "Optimizing assets...",
    "Finalizing setup..."
]

// Pick a random message once
const randomIndex = Math.floor(Math.random() * loadingMessages.length)
const currentMessage = ref(loadingMessages[randomIndex])

// Matrix effect
const initMatrixEffect = () => {
    if (!matrixCanvas.value) return

    const canvas = matrixCanvas.value
    const ctx = canvas.getContext('2d')
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight

    // Hiragana: あいうえお... | Katakana: アイウエオ... | Binary: 01
    const characters = '01あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン'
    const fontSize = 14
    const columns = canvas.width / fontSize
    const drops = Array(Math.floor(columns)).fill(1)

    const draw = () => {
        ctx.fillStyle = 'rgba(15, 20, 25, 0.05)'
        ctx.fillRect(0, 0, canvas.width, canvas.height)

        ctx.fillStyle = '#ff4757'
        ctx.font = `${fontSize}px monospace`

        for (let i = 0; i < drops.length; i++) {
            const text = characters[Math.floor(Math.random() * characters.length)]
            ctx.fillText(text, i * fontSize, drops[i] * fontSize)

            if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                drops[i] = 0
            }
            drops[i]++
        }
    }

    const animate = () => {
        draw()
        matrixAnimationId = requestAnimationFrame(animate)
    }

    animate()
}

// Particle effect
const initParticleEffect = () => {
    if (!particleCanvas.value) return

    const canvas = particleCanvas.value
    const ctx = canvas.getContext('2d')
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight

    class Particle {
        constructor() {
            this.reset()
        }

        reset() {
            this.x = Math.random() * canvas.width
            this.y = Math.random() * canvas.height
            this.vx = (Math.random() - 0.5) * 0.5
            this.vy = (Math.random() - 0.5) * 0.5
            this.radius = Math.random() * 2 + 1
            this.opacity = Math.random() * 0.5 + 0.2
        }

        update() {
            this.x += this.vx
            this.y += this.vy

            if (this.x < 0 || this.x > canvas.width) this.vx *= -1
            if (this.y < 0 || this.y > canvas.height) this.vy *= -1
        }

        draw() {
            ctx.beginPath()
            ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2)
            ctx.fillStyle = `rgba(255, 71, 87, ${this.opacity})`
            ctx.fill()
        }
    }

    const particles = Array(50).fill(null).map(() => new Particle())

    const animate = () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height)

        particles.forEach(particle => {
            particle.update()
            particle.draw()
        })

        // Draw connections
        particles.forEach((p1, i) => {
            particles.slice(i + 1).forEach(p2 => {
                const dx = p1.x - p2.x
                const dy = p1.y - p2.y
                const distance = Math.sqrt(dx * dx + dy * dy)

                if (distance < 150) {
                    ctx.beginPath()
                    ctx.moveTo(p1.x, p1.y)
                    ctx.lineTo(p2.x, p2.y)
                    ctx.strokeStyle = `rgba(255, 71, 87, ${0.15 * (1 - distance / 150)})`
                    ctx.lineWidth = 0.5
                    ctx.stroke()
                }
            })
        })

        particleAnimationId = requestAnimationFrame(animate)
    }

    animate()
}

// Glitch effect trigger
const triggerGlitch = () => {
    shouldGlitch.value = true
    setTimeout(() => {
        shouldGlitch.value = false
    }, 200)
}

// Resize handler
const handleResize = () => {
    if (matrixCanvas.value) {
        matrixCanvas.value.width = window.innerWidth
        matrixCanvas.value.height = window.innerHeight
    }
    if (particleCanvas.value) {
        particleCanvas.value.width = window.innerWidth
        particleCanvas.value.height = window.innerHeight
    }
}

onMounted(() => {
    scheduler.clearAllWithTag(schedulerTag)
    _performTransition()

    // Initialize effects with slight delay for better performance
    setTimeout(() => {
        initMatrixEffect()
        initParticleEffect()
    }, 100)

    // Trigger glitch periodically
    const glitchInterval = setInterval(() => {
        if (currentStep.value >= Steps.ANIMATING_LOGO && currentStep.value < Steps.LEAVING) {
            triggerGlitch()
        }
    }, 3000)

    // Add resize listener
    window.addEventListener('resize', handleResize)

    // Cleanup
    onUnmounted(() => {
        clearInterval(glitchInterval)
        window.removeEventListener('resize', handleResize)
        if (matrixAnimationId) cancelAnimationFrame(matrixAnimationId)
        if (particleAnimationId) cancelAnimationFrame(particleAnimationId)
    })
})

watch(() => props.visible, () => {
    scheduler.clearAllWithTag(schedulerTag)
    _performTransition()
})

watch(() => props.refreshCount, () => {
    scheduler.clearAllWithTag(schedulerTag)
    percentage.value = 0
    currentStep.value = Steps.NONE
    _executeAnimatingLogoStep()
})

const _onLogoLoaded = () => {
    didLoadLogo.value = true
}

const _performTransition = () => {
    if(!props.visible)
        return

    percentage.value = 0
    currentStep.value = Steps.NONE

    if(props.smoothTransitionEnabled)
        _executeEnteringStep()
    else
        _executeAnimatingLogoStep()
}

const _executeEnteringStep = () => {
    currentStep.value = Steps.WILL_ENTER

    scheduler.schedule(() => {
        currentStep.value = Steps.ENTERING
    }, 30, schedulerTag)

    scheduler.schedule(() => {
        _executeAnimatingLogoStep()
    }, 350, schedulerTag)
}

const _executeAnimatingLogoStep = () => {
    currentStep.value = Steps.LOADING_LOGO
    canScroll.value = false

    if(!didLoadLogo.value) {
        scheduler.schedule(() => {
            _executeAnimatingLogoStep()
        }, 100, schedulerTag)
        return
    }

    currentStep.value = Steps.ANIMATING_LOGO
    scheduler.schedule(() => {
        _executeAnimatingProgressStep()
    }, 300, schedulerTag)
}

const _executeAnimatingProgressStep = () => {
    currentStep.value = Steps.ANIMATING_PROGRESS
    scheduler.schedule(() => {
        _executeWaitingForCompletionStep()
    }, 200, schedulerTag)
}

const _executeWaitingForCompletionStep = () => {
    currentStep.value = Steps.WAITING_FOR_COMPLETION

    const dt = 1000 / 30
    loadingTime.value = 0
    loadingTimeAfterRendering.value = 0
    didEmitReady.value = false

    scheduler.interval(() => {
        _updateProgress(dt)
    }, dt, schedulerTag)
}

const _updateProgress = (dt) => {
    const isPageLoaded = Boolean(document.querySelector('#resume'))

    loadingTime.value += isPageLoaded ?
        dt :
        dt / Math.max(4, percentage.value)

    loadingTimeAfterRendering.value += isPageLoaded ?
        dt :
        0

    const imageLoadPercentage = _getImageLoadPercentage()
    const minTimePercentage = utils.clamp(loadingTime.value*80/500, 0, 100)
    const minTimePercentageAfterRendering = utils.clamp(loadingTimeAfterRendering.value*100/500, 0, 100)

    const currentPercentage = (imageLoadPercentage + minTimePercentage + minTimePercentageAfterRendering)/3
    _incrementDisplayPercentage(currentPercentage)
}

const _getImageLoadPercentage = () => {
    const imageElements = document.querySelectorAll(".image")
    const imageLoadProgress = {loaded: 0, total: 0}
    Array.from(imageElements).forEach(item => {
        imageLoadProgress.total++
        if(item.getAttribute('load-status') === "loaded" || item.getAttribute('load-status') === "error")
            imageLoadProgress.loaded++
    })

    if(imageLoadProgress.total < 2)
        return 0
    return utils.clamp(imageLoadProgress.loaded*100/imageLoadProgress.total, 0, 100)
}

const _incrementDisplayPercentage = (currentPercentage) => {
    const diff = currentPercentage - percentage.value
    const smootheningPercentageIncrement = diff > 8 ? 8 : Math.round(diff)
    percentage.value += smootheningPercentageIncrement
    percentage.value = utils.clamp(percentage.value, 0, 100)

    if(percentage.value > 5 && !didEmitReady.value) {
        emit('ready')
    }

    if(percentage.value === 100 || loadingTimeAfterRendering.value >= 5000) {
        _onLoadingComplete()
    }
}

const _onLoadingComplete = () => {
    scheduler.schedule(() => {
        percentage.value = 100
        _executeLeavingStep()
    }, 300, schedulerTag)
}

const _executeLeavingStep = () => {
    currentStep.value = Steps.LEAVING
    canScroll.value = true
    scheduler.schedule(() => {
        emit('completed')
    }, 900, schedulerTag)
}
</script>

<style lang="scss" scoped>
@import "/src/scss/_theming.scss";

div.resume-loader {
    position: fixed;
    z-index: $z-index-loader;
    user-select: none;

    display: flex;
    justify-content: center;
    align-items: center;

    background-color: #0f1419;
    width: 100vw;
    height: 125vh;
    height: 125svh;
    top: -12.5vh;
    top: -12.5svh;
    transition: opacity 0.3s ease-in;
    overflow: hidden;

    &-tween-in {
        opacity: 0;
        transition: none!important;
        user-select: none;
        pointer-events: none;
    }

    &-tween-out {
        top: -125vh;
        transition: 1.2s top cubic-bezier(0.68, -0.55, 0.265, 1.55);
    }
}

// Canvas backgrounds
canvas.matrix-canvas,
canvas.particle-canvas {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
}

canvas.matrix-canvas {
    opacity: 0.15;
    z-index: 1;
}

canvas.particle-canvas {
    opacity: 0.6;
    z-index: 2;
}

div.resume-loader-content {
    color: $light;
    text-align: center;
    padding-bottom: 5rem;
    z-index: 10;
    position: relative;
}

div.logo-container {
    position: relative;
    display: inline-block;
}

div.image-view-logo {
    width: 80px;
    height: 80px;
    z-index: 10;
    opacity: 0;
    position: relative;

    // Responsive sizing
    @media (max-width: 768px) {
        width: 70px;
        height: 70px;
    }

    @media (max-width: 480px) {
        width: 60px;
        height: 60px;
    }

    &-animated {
        animation: popInWithGlow 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55) forwards;
    }

    &-glitch {
        animation: glitch 0.2s linear;
    }
}

div.resume-loader-progress-display {
    margin-top: 30px;
    overflow: hidden;
    z-index: 5;
    transition: 0.3s all ease-out;

    &-hidden {
        opacity: 0;
        margin-top: 0;
    }

    .loading-message {
        color: #ff4757;
        margin-bottom: 10px;
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
        font-weight: 500;
        letter-spacing: 0.5px;
        animation: fadeInOut 2s ease-in-out infinite;

        @media (max-width: 768px) {
            font-size: 0.8rem;
        }

        @media (max-width: 480px) {
            font-size: 0.75rem;
            margin-bottom: 8px;
        }
    }

    p.percentage {
        color: $light;
        margin-bottom: 10px;
        font-family: 'Courier New', monospace;
        font-size: 1.2rem;
        font-weight: 700;
        text-shadow: 0 0 10px rgba(255, 71, 87, 0.5);

        @media (max-width: 768px) {
            font-size: 1.1rem;
        }

        @media (max-width: 480px) {
            font-size: 1rem;
            margin-bottom: 8px;
        }
    }

    .resume-loader-progress-bar {
        max-width: 200px;
        margin: 0 auto;
        box-shadow: 0 0 20px rgba(255, 71, 87, 0.3);

        @media (max-width: 768px) {
            max-width: 180px;
        }

        @media (max-width: 480px) {
            max-width: 150px;
        }
    }
}

div.transition-none {
    transition: none!important;
}

// Animations
@keyframes popInWithGlow {
    0% {
        opacity: 0;
        transform: scale(0.3) translateY(-50px) rotate(-10deg);
        filter: blur(10px) drop-shadow(0 0 0 rgba(255, 71, 87, 0));
    }
    50% {
        transform: scale(1.1) rotate(2deg);
        filter: blur(0) drop-shadow(0 0 20px rgba(255, 71, 87, 0.8));
    }
    100% {
        opacity: 1;
        transform: scale(1) rotate(0deg);
        filter: blur(0) drop-shadow(0 0 15px rgba(255, 71, 87, 0.6));
    }
}

@keyframes glitch {
    0%, 100% {
        transform: translate(0);
        filter: drop-shadow(0 0 15px rgba(255, 71, 87, 0.6));
    }
    10% {
        transform: translate(-2px, 2px);
        filter: drop-shadow(0 0 20px rgba(255, 71, 87, 1)) hue-rotate(90deg);
    }
    20% {
        transform: translate(2px, -2px);
        filter: drop-shadow(0 0 20px rgba(255, 71, 87, 1)) hue-rotate(-90deg);
    }
    30% {
        transform: translate(-2px, -2px);
        filter: drop-shadow(0 0 25px rgba(255, 71, 87, 1));
    }
    40% {
        transform: translate(2px, 2px);
        filter: drop-shadow(0 0 20px rgba(255, 71, 87, 1)) hue-rotate(45deg);
    }
    50% {
        transform: translate(-2px, 2px);
        filter: drop-shadow(0 0 30px rgba(255, 71, 87, 1));
    }
}

@keyframes fadeInOut {
    0%, 100% {
        opacity: 0.7;
    }
    50% {
        opacity: 1;
    }
}

// Reduced motion support for accessibility
@media (prefers-reduced-motion: reduce) {
    div.image-view-logo-animated {
        animation: simpleFadeIn 0.3s ease-out forwards;
    }

    div.image-view-logo-glitch {
        animation: none;
    }

    .loading-message {
        animation: none !important;
        opacity: 1;
    }

    canvas.matrix-canvas,
    canvas.particle-canvas {
        display: none;
    }

    @keyframes simpleFadeIn {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
}

// Performance optimization: GPU acceleration
div.image-view-logo,
canvas.matrix-canvas,
canvas.particle-canvas {
    will-change: transform;
    transform: translateZ(0);
    backface-visibility: hidden;
}
</style>
