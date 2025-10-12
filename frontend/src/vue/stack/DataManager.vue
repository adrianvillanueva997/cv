<template>
    <slot v-if="settings"/>
</template>

<script setup>
import { onMounted, provide, ref } from "vue"
import { useUtils } from "/src/composables/utils.js"
import categoriesData from '/src/data/categories.yaml'
import profileData from '/src/data/profile.yaml'
import achievementsData from '/src/data/sections/achievements.yaml'
import contactData from '/src/data/sections/contact.yaml'
import coverData from '/src/data/sections/cover.yaml'
import educationData from '/src/data/sections/education.yaml'
import experienceData from '/src/data/sections/experience.yaml'
import hobbiesData from '/src/data/sections/hobbies.yaml'
import portfolioData from '/src/data/sections/portfolio.yaml'
import skillsData from '/src/data/sections/skills.yaml'
// Import section YAML files
import sectionsData from '/src/data/sections.yaml'
// Import all YAML data at build time (not publicly accessible)
import settingsData from '/src/data/settings.yaml'
import stringsData from '/src/data/strings.yaml'
import Category from "/src/models/Category.js"
import Locales from "/src/models/Locales.js"
import Profile from "/src/models/Profile.js"
import Section from "/src/models/Section.js"
import Settings from "/src/models/Settings.js"

// Map section paths to imported data
const sectionDataMap = {
    '/sections/achievements.json': achievementsData,
    '/sections/contact.json': contactData,
    '/sections/cover.json': coverData,
    '/sections/education.json': educationData,
    '/sections/experience.json': experienceData,
    '/sections/hobbies.json': hobbiesData,
    '/sections/portfolio.json': portfolioData,
    '/sections/skills.json': skillsData
}

const utils = useUtils()

const categories = ref(null)
const profile = ref(null)
const sections = ref(null)
const settings = ref(null)
const strings = ref(null)
const didLoadAllJsonFiles = ref(false)

onMounted(() => {
    _load()
    didLoadAllJsonFiles.value = true
})

const _load = () => {
    settings.value = new Settings(settingsData)
    strings.value = new Locales(stringsData)
    profile.value = new Profile(profileData)

    _parseSectionsAndCategories(sectionsData['sections'], categoriesData['categories'])
    _validateSectionsAndCategories()
    _loadSectionJsonFiles()
}

const _parseSectionsAndCategories = (sectionsList, categoriesList) => {
    const parsedSections = []
    const parsedCategories = []

    for(const categoryListItem of categoriesList) {
        const category = new Category(categoryListItem['id'], categoryListItem['faIcon'], categoryListItem['locales'])
        parsedCategories.push(category)
    }

    for(const sectionsListItem of sectionsList) {
        const section = new Section(
            sectionsListItem['id'],
            parsedSections.length === 0,
            sectionsListItem['faIcon'],
            sectionsListItem['jsonPath'],
            sectionsListItem['type'],
            sectionsListItem['locales']
        )

        const sectionCategory = parsedCategories.find(category => category.id === sectionsListItem['categoryId'])
        if(!sectionCategory) {
            throw new Error(`The section with id "${section.id}" has an invalid category id. Make sure the category with id "${sectionsListItem['categoryId']}" exists.`)
        }

        parsedSections.push(section)
        section.category = sectionCategory
        sectionCategory.addSection(section)
    }

    sections.value = parsedSections
    categories.value = parsedCategories.filter(category => category.sections.length)
}

const _validateSectionsAndCategories = () => {
    if(utils.hasDuplications(sections.value, "id")) {
        throw new Error("Each section must have an unique id!")
    }

    if(utils.hasDuplications(categories.value, "id")) {
        throw new Error("Each category must have an unique id!")
    }
}

const _loadSectionJsonFiles = () => {
    for(const section of sections.value) {
        const path = section.jsonPath
        if(!path)
            continue

        const json = sectionDataMap[path]
        if(!json) {
            throw new Error(`${path} not found in section data map.`)
        }

        const articles = json['articles']
        if(!articles) {
            throw new Error(`${path} doesn't have an articles array.`)
        }

        section.articles = articles
    }
}

provide("categories", categories)
provide("profile", profile)
provide("sections", sections)
provide("settings", settings)
provide("strings", strings)
provide("didLoadAllJsonFiles", didLoadAllJsonFiles)
</script>

<style lang="scss" scoped>
@import "/src/scss/_theming.scss";
</style>
