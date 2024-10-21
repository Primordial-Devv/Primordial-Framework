<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

const showNotification = ref(false)
const messageNotification = ref('TESTTTTTTTTTTTTTTTTTTTT')
const imageNotification = ref('https://cdn.discordapp.com/attachments/1246185100996116551/1291123497535541299/image.png?ex=67023fb5&is=6700ee35&hm=57737c250d65cea6b7a5464e6084518388ab2658c3a5a04cf2eb6ee0af157e72&')
const hasImage = ref(true)
const colorNotification = ref('#000000')
const durationNotification = ref(5000)

// const fontSize = computed(() => {
//   const length = messageNotification.value.length
//   if (length <= 20) {
//     return '30px'
//   } else if (length <= 50) {
//     return '24px'
//   } else {
//     return '18px'
//   }
// })

onMounted(() => {
  window.addEventListener('message', (event) => {
    if ( event.data.action === 'showNotification') {
      messageNotification.value = event.data.message
      imageNotification.value = event.data.image
      hasImage.value = event.data.hasImage
      colorNotification.value = event.data.color || '#000000'
      durationNotification.value = event.data.duration || 5000
      showNotification.value = true

      console.log('Notification received', event.data)
      if (event.data.image) {
        console.log('Image' + event.data.image)
      }
      else {
          console.log('Image ' + imageNotification.value)
      }
      setTimeout(() => {
        showNotification.value = false
      }, durationNotification.value)
      console.log('Notification displayed')
    }
  })
})

onBeforeUnmount(() => {
  window.removeEventListener('message', () => {})
})
</script>

<template>
<!--<div v-if="showNotification" class="notification" v-bind:style="{ borderColor: colorNotification }">-->
<div class="notification">
  <img v-if="hasImage" class="image-notification" :src="imageNotification" alt="Image Notification">
  <div class="text-notification" :style="{ fontSize: fontSize }"> {{ messageNotification }}</div>
</div>
</template>

<style scoped>
.notification {
  width: 20vw;
  height: 10vh;
  background-color: rgba(0, 0, 0, 0.8);
  border: 3px solid;
  border-radius: 12px;
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 50%;
  left: 0;
  transform: translateY(-50%);
  margin-left: 50px;
  padding-left: 20px;
  padding-top: 5px;
  padding-bottom: 5px;
}

.image-notification {
  width: 25%;
  height: 80%;
}

.text-notification {
  color: white;
  margin-left: 10px;
  margin-right: 10px;
  flex-grow: 1;
}
</style>
