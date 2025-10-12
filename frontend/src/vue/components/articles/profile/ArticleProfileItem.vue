<template>
    <p class="terminal-paragraph"
       v-html="localize(item.locales, 'description')"/>
</template>

<script setup>
import { inject } from "vue";

const props = defineProps({
    item: {
        /** @type {ArticleItem} **/
        type: Object,
        required: true
    }
})

/** @type {Function} */
const localize = inject("localize")
</script>

<style lang="scss" scoped>
@import "/src/scss/_theming.scss";

.terminal-paragraph {
    font-family: $font-family-monospace;
    color: $terminal-text;
    line-height: 1.8;
    margin-bottom: 1rem;
    font-size: 0.95rem;

    @include media-breakpoint-down(lg) {
        font-size: 0.9rem;
    }

    @include media-breakpoint-down(md) {
        font-size: 0.85rem;
        line-height: 1.7;
    }
}
</style>