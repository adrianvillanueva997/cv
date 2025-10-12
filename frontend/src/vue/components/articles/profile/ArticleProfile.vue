<template>
    <Article class="article-profile article-profile-terminal"
             :model="model">
        <!-- Terminal Header with Prompt -->
        <div class="terminal-header">
            <div class="terminal-controls">
                <span class="terminal-dot dot-red"></span>
                <span class="terminal-dot dot-yellow"></span>
                <span class="terminal-dot dot-green"></span>
            </div>
            <div class="terminal-title">adrian@home:~$</div>
        </div>

        <!-- Terminal Content -->
        <div class="terminal-body">
            <!-- Command Prompt Line -->
            <div class="terminal-prompt-line">
                <span class="prompt-symbol">></span>
                <span class="prompt-command">whoami</span>
            </div>

            <!-- Name with Typing Effect -->
            <h1 class="title terminal-output-name"
                :class="{ 'typing-complete': typingComplete }">
                <span ref="typedName" class="typed-text"></span>
                <span class="terminal-cursor" v-show="showCursor">▊</span>
            </h1>

            <!-- Status Line -->
            <div class="terminal-status-line">
                <span class="status-item">
                    <span class="status-label">role:</span>
                    <span class="status-value">Senior Software Engineer</span>
                </span>
                <span class="status-divider">|</span>
                <span class="status-item">
                    <span class="status-label">location:</span>
                    <span class="status-value">Tokyo, JP</span>
                </span>
                <span class="status-divider">|</span>
                <span class="status-item">
                    <span class="status-label">status:</span>
                    <span class="status-value status-available">available</span>
                </span>
            </div>

            <!-- Description Command -->
            <div class="terminal-prompt-line mt-4">
                <span class="prompt-symbol">></span>
                <span class="prompt-command">cat about.txt</span>
            </div>

            <!-- Description Items -->
            <div class="items-wrapper terminal-output">
                <ArticleProfileItem v-for="item in model.items"
                                    :item="item"/>
            </div>

            <!-- Social Links Command -->
            <div class="terminal-prompt-line mt-4">
                <span class="prompt-symbol">></span>
                <span class="prompt-command">ls -la ./social/</span>
            </div>

            <SocialLinks :items="socialLinks"
                         class="terminal-social-links"
                         size="3"
                         variant="dark"/>

            <!-- Download CV Command -->
            <div class="terminal-prompt-line mt-4">
                <span class="prompt-symbol">></span>
                <span class="prompt-command">wget resume.pdf</span>
            </div>

            <a href="/resume.pdf"
               download="Adrian_Villanueva_Resume.pdf"
               class="terminal-download-button">
                <i class="fas fa-download"></i>
                <span>Download Resume</span>
                <span class="file-size">[PDF • ~150KB]</span>
            </a>

            <!-- Blinking Cursor at End -->
            <div class="terminal-prompt-line mt-4">
                <span class="prompt-symbol">></span>
                <span class="terminal-cursor blinking">▊</span>
            </div>
        </div>

        <!-- Scanline Effect Overlay -->
        <div class="terminal-scanlines"></div>
    </Article>
</template>

<script setup>
import { computed, inject, onMounted, ref } from "vue"
import Article from "/src/vue/components/articles/base/Article.vue"
import ArticleProfileItem from "/src/vue/components/articles/profile/ArticleProfileItem.vue"
import SocialLinks from "/src/vue/components/widgets/SocialLinks.vue"

const props = defineProps({
    model: {
        /** @type {Article} **/
        type: Object,
        required: true
    }
})

/** @type {Function} */
const localize = inject("localize")

/** @type {{value:Profile}} */
const profile = inject("profile")

/** @type {{value:Boolean}} */
const isScreenXlOrLarger = inject("isScreenXlOrLarger")

const title = computed(() => {
    return localize(
        props.model.section.locales,
        isScreenXlOrLarger.value ? "title" : "title_short"
    )
})

const socialLinks = computed(() => {
    const contactIds = props.model.getSetting("contact_circles_ids", [])
    return contactIds.map(contactId => {
        return profile.value.getContactOptionWithId(contactId)
    }).filter(contact => Boolean(contact))
})

// Typing effect
const typedName = ref(null)
const showCursor = ref(true)
const typingComplete = ref(false)

onMounted(() => {
    // Start typing animation after a brief delay
    setTimeout(() => {
        typeText()
    }, 500)

    // Cursor blink animation
    setInterval(() => {
        showCursor.value = !showCursor.value
    }, 530)
})

const typeText = () => {
    const fullText = title.value.replace(/<[^>]*>/g, '') // Strip HTML tags
    let currentIndex = 0

    const typingInterval = setInterval(() => {
        if (currentIndex < fullText.length) {
            if (typedName.value) {
                typedName.value.textContent = fullText.substring(0, currentIndex + 1)
            }
            currentIndex++
        } else {
            clearInterval(typingInterval)
            typingComplete.value = true
        }
    }, 80) // 80ms per character
}
</script>

<style lang="scss" scoped>
@import "/src/scss/_theming.scss";

// Terminal Container
.article-profile-terminal {
    position: relative;
    background: $terminal-bg;
    border: 2px solid $terminal-border;
    border-radius: 8px;
    box-shadow:
        0 0 20px rgba(255, 71, 87, 0.2),
        0 0 40px rgba(255, 71, 87, 0.1),
        inset 0 0 60px rgba(0, 0, 0, 0.5);
    overflow: hidden;

    // Apply monospace to all text
    font-family: $font-family-monospace;
    color: $terminal-text;
}

// Terminal Header (macOS-style dots)
.terminal-header {
    display: flex;
    align-items: center;
    padding: 12px 16px;
    background: rgba(0, 0, 0, 0.3);
    border-bottom: 1px solid rgba(255, 71, 87, 0.2);
}

.terminal-controls {
    display: flex;
    gap: 8px;
    margin-right: 16px;
}

.terminal-dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;

    &.dot-red { background: #ff5f56; }
    &.dot-yellow { background: #ffbd2e; }
    &.dot-green { background: #27c93f; }
}

.terminal-title {
    color: $terminal-cyan;
    font-size: 0.9rem;
    font-weight: 600;
}

// Terminal Body
.terminal-body {
    padding: 24px;
    position: relative;
    z-index: 2;

    @include media-breakpoint-down(lg) {
        padding: 20px;
    }

    @include media-breakpoint-down(md) {
        padding: 16px;
    }
}

// Prompt Line
.terminal-prompt-line {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 8px;
}

.prompt-symbol {
    color: $terminal-prompt;
    font-weight: 700;
    font-size: 1.1rem;
}

.prompt-command {
    color: $terminal-green;
    font-size: 0.95rem;
}

// Name Output with Typing Effect
.terminal-output-name {
    font-size: clamp(2rem, 5vw, 3.5rem);
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 3px;
    margin: 16px 0 24px 0;
    color: $terminal-red;
    text-shadow:
        0 0 10px rgba(255, 71, 87, 0.5),
        0 0 20px rgba(255, 71, 87, 0.3);

    @include media-breakpoint-down(lg) {
        font-size: clamp(1.5rem, 4vw, 2.5rem);
        letter-spacing: 2px;
    }
}

.typed-text {
    display: inline-block;
}

.terminal-cursor {
    color: $terminal-cursor;
    animation: none;
    margin-left: 2px;

    &.blinking {
        animation: blink 1.06s infinite;
    }
}

@keyframes blink {
    0%, 49% { opacity: 1; }
    50%, 100% { opacity: 0; }
}

// Status Line
.terminal-status-line {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    font-size: 0.9rem;
    margin-bottom: 16px;

    @include media-breakpoint-down(md) {
        font-size: 0.8rem;
        gap: 8px;
    }
}

.status-item {
    display: flex;
    gap: 6px;
}

.status-label {
    color: $terminal-cyan;
}

.status-value {
    color: $terminal-text;

    &.status-available {
        color: $terminal-green;
        font-weight: 600;
    }
}

.status-divider {
    color: rgba(255, 255, 255, 0.3);
}

// Description Output
.terminal-output {
    margin: 12px 0;
    line-height: 1.8;
    color: $terminal-text;
    font-size: 0.95rem;

    @include media-breakpoint-down(md) {
        font-size: 0.85rem;
    }
}

// Social Links
.terminal-social-links {
    margin-top: 12px;

    :deep(a) {
        transition: all 0.3s ease;

        &:hover {
            transform: translateY(-2px);
            filter: drop-shadow(0 0 8px rgba(255, 71, 87, 0.6));
        }
    }
}

// Download Button
.terminal-download-button {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    margin-top: 12px;
    padding: 12px 24px;
    background: linear-gradient(135deg, $terminal-red 0%, darken($terminal-red, 10%) 100%);
    border: 2px solid $terminal-red;
    border-radius: 4px;
    color: $terminal-text;
    font-family: $font-family-monospace;
    font-size: 0.9rem;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s ease;
    box-shadow:
        0 4px 15px rgba(255, 71, 87, 0.3),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);

    &:hover {
        transform: translateY(-2px);
        box-shadow:
            0 6px 20px rgba(255, 71, 87, 0.5),
            0 0 30px rgba(255, 71, 87, 0.3),
            inset 0 1px 0 rgba(255, 255, 255, 0.2);
        border-color: lighten($terminal-red, 10%);
        color: #fff;
    }

    &:active {
        transform: translateY(0);
        box-shadow:
            0 2px 10px rgba(255, 71, 87, 0.4),
            inset 0 1px 0 rgba(255, 255, 255, 0.1);
    }

    i {
        font-size: 1rem;
    }

    .file-size {
        margin-left: 8px;
        font-size: 0.75rem;
        opacity: 0.8;
        font-weight: 400;
    }

    @include media-breakpoint-down(md) {
        padding: 10px 20px;
        font-size: 0.85rem;
        gap: 8px;

        .file-size {
            display: none;
        }
    }
}

// Scanline Effect (CRT monitor aesthetic)
.terminal-scanlines {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 1;

    background: repeating-linear-gradient(
        0deg,
        transparent,
        transparent 2px,
        $terminal-scanline 2px,
        $terminal-scanline 4px
    );

    animation: scanline-move 8s linear infinite;

    @media (prefers-reduced-motion: reduce) {
        animation: none;
    }
}

@keyframes scanline-move {
    0% { transform: translateY(0); }
    100% { transform: translateY(100%); }
}

// Mobile Adjustments
@include media-breakpoint-down($navigation-sidebar-breakpoint) {
    .terminal-header {
        padding: 10px 12px;
    }

    .terminal-dot {
        width: 10px;
        height: 10px;
    }

    .terminal-title {
        font-size: 0.75rem;
    }

    .terminal-output-name {
        margin: 12px 0 16px 0;
    }
}

// Hide old title on mobile (keep terminal version)
h1.title:not(.terminal-output-name) {
    @include media-breakpoint-down($navigation-sidebar-breakpoint) {
        display: none;
    }
}
</style>
