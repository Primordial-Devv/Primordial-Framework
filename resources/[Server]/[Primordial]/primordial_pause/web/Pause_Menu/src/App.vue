<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

import playerID from './assets/player_id_icon.svg'
import playerName from './assets/player_name_icon.svg'
import leaveIcon from './assets/leave-icon.svg'
import rulesIcon from './assets/rules_icon.svg'
import discordIcon from './assets/discord_icon.svg'
import settingsIcon from './assets/settings_icon.svg'
import websiteIcon from './assets/website-icon.svg'
import shoppingIcon from './assets/shopping-icon.svg'



const leaveBox = ref(null)
const mapBox = ref(null)
const rulesBox = ref(null)
const discordBox = ref(null)
const shoppingBox = ref(null)
const settingsBox = ref(null)
const websiteBox = ref(null)

const isVisible = ref(false)

const closeMenu = () => {
  isVisible.value = false
  fetch('https://primordial_pause/close', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({}),
  })
}

const openMenu = () => {
  isVisible.value = true
  fetch('https://primordial_pause/open', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({}),
  })
}

const handleKeyDown = (e) => {
  if (e.key === 'Escape') {
    isVisible.value = !isVisible.value
    if (isVisible.value) {
      openMenu()
    } else {
      closeMenu()
    }
  }
}

const handleMouseMove = (e, box) => {
  const { width, height, left, top } = box.getBoundingClientRect()

  const x = e.clientX - left - width / 2
  const y = e.clientY - top - height / 2

  const rotateX = (y / height) * 30
  const rotateY = (x / width) * -30

  box.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`
}

const handleMouseLeave = (box) => {
  box.style.transform = `perspective(1000px) rotateX(0deg) rotateY(0deg)`
}

onMounted(() => {
  if (leaveBox.value) {
    leaveBox.value.addEventListener('mousemove', (e) => handleMouseMove(e, leaveBox.value))
    leaveBox.value.addEventListener('mouseleave', () => handleMouseLeave(leaveBox.value))
  }

  if (mapBox.value) {
    mapBox.value.addEventListener('mousemove', (e) => handleMouseMove(e, mapBox.value))
    mapBox.value.addEventListener('mouseleave', () => handleMouseLeave(mapBox.value))
  }

  if (rulesBox.value) {
    rulesBox.value.addEventListener('mousemove', (e) => handleMouseMove(e, rulesBox.value))
    rulesBox.value.addEventListener('mouseleave', () => handleMouseLeave(rulesBox.value))
  }

  if (discordBox.value) {
    discordBox.value.addEventListener('mousemove', (e) => handleMouseMove(e, discordBox.value))
    discordBox.value.addEventListener('mouseleave', () => handleMouseLeave(discordBox.value))
  }

  if (shoppingBox.value) {
    shoppingBox.value.addEventListener('mousemove', (e) => handleMouseMove(e, shoppingBox.value))
    shoppingBox.value.addEventListener('mouseleave', () => handleMouseLeave(shoppingBox.value))
  }

  if (settingsBox.value) {
    settingsBox.value.addEventListener('mousemove', (e) => handleMouseMove(e, settingsBox.value))
    settingsBox.value.addEventListener('mouseleave', () => handleMouseLeave(settingsBox.value))
  }

  if (websiteBox.value) {
    websiteBox.value.addEventListener('mousemove', (e) => handleMouseMove(e, websiteBox.value))
    websiteBox.value.addEventListener('mouseleave', () => handleMouseLeave(websiteBox.value))
  }

  window.addEventListener('keydown', handleKeyDown)

  window.addEventListener('message', (event) => {
    console.log('Message reçu:', event.data)

    if (event.data.action === 'open') {
      console.log('Ouverture du menu pause')
      isVisible.value = true
    } else if (event.data.action === 'close') {
      console.log('Fermeture du menu pause')
      isVisible.value = false
    }
  })
})

onBeforeUnmount(() => {
  if (leaveBox.value) {
    leaveBox.value.removeEventListener('mousemove', (e) => handleMouseMove(e, leaveBox.value))
    leaveBox.value.removeEventListener('mouseleave', () => handleMouseLeave(leaveBox.value))
  }

  if (mapBox.value) {
    mapBox.value.removeEventListener('mousemove', (e) => handleMouseMove(e, mapBox.value))
    mapBox.value.removeEventListener('mouseleave', () => handleMouseLeave(mapBox.value))
  }

  if (rulesBox.value) {
    rulesBox.value.removeEventListener('mousemove', (e) => handleMouseMove(e, rulesBox.value))
    rulesBox.value.removeEventListener('mouseleave', () => handleMouseLeave(rulesBox.value))
  }

  if (discordBox.value) {
    discordBox.value.removeEventListener('mousemove', (e) => handleMouseMove(e, discordBox.value))
    discordBox.value.removeEventListener('mouseleave', () => handleMouseLeave(discordBox.value))
  }

  if (shoppingBox.value) {
    shoppingBox.value.removeEventListener('mousemove', (e) => handleMouseMove(e, shoppingBox.value))
    shoppingBox.value.removeEventListener('mouseleave', () => handleMouseLeave(shoppingBox.value))
  }

  if (settingsBox.value) {
    settingsBox.value.removeEventListener('mousemove', (e) => handleMouseMove(e, settingsBox.value))
    settingsBox.value.removeEventListener('mouseleave', () => handleMouseLeave(settingsBox.value))
  }

  if (websiteBox.value) {
    websiteBox.value.removeEventListener('mousemove', (e) => handleMouseMove(e, websiteBox.value))
    websiteBox.value.removeEventListener('mouseleave', () => handleMouseLeave(websiteBox.value))
  }

  window.removeEventListener('keydown', handleKeyDown)
})
</script>

<template>
  <div class="pause-menu">
    <div class="pause-menu-content">
      <div class="header-content">
        <div class="player-information">
          <img class="player-picture" src="./assets/vue.svg" alt="Player Picture"/>
          <div class="player-specs">
            <div class="player-name">
              <img class="player-name-icon" v-bind:src='playerName' alt="Icon Player Name">
              <p id="player-name-text">Player Name</p>
            </div>
            <div class="player-id">
              <img class="player-id-icon" v-bind:src="playerID" alt="Icon Player ID">
              <p>Player ID</p>
            </div>
          </div>
        </div>

        <div class="server-name">
          <h2 id="server-name-text">AMBITIONS</h2>
        </div>

        <div class="leave-information" ref="leaveBox">
          <img class="leave-icon" v-bind:src="leaveIcon" alt="Leave Icon">
          <p>Leave</p>
        </div>
      </div>

      <div class="body-content">
        <div class="map-information" ref="mapBox">
          <div class="info-box">
            <p>Map</p>
          </div>
        </div>
        <div class="list-infos">
          <div class="rules-infos" ref="rulesBox">
            <img class="rules-icon" v-bind:src="rulesIcon" alt="Rules Icon">
            <div class="info-box">
              <p>Rules</p>
            </div>
          </div>
          <div class="discord-infos" ref="discordBox">
            <img class="discord-icon" v-bind:src="discordIcon" alt="Discord icon">
            <div class="info-box">
              <p>Discord Server</p>
            </div>
          </div>
          <div class="shopping-infos" ref="shoppingBox">
            <img class="shopping-icon" v-bind:src="shoppingIcon" alt="Shopping Icon">
            <div class="info-box">
              <p>Shopping Website</p>
            </div>
          </div>
        </div>
        <div class="second-list-infos">
          <div class="settings-infos" ref="settingsBox">
            <img class="settings-icon" v-bind:src="settingsIcon" alt="Settings Icon">
            <div class="info-box">
              <p>Settings</p>
            </div>
          </div>
          <div class="website-infos" ref="websiteBox">
            <img class="website-icon" v-bind:src="websiteIcon" alt="Website Icon">
            <div class="info-box">
              <p>Website</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
* {
  box-sizing: border-box;
}

.pause-menu {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.8);
}

.pause-menu-content {
  width: 85%;
  height: 80%;
  display: flex;
  flex-direction: column;
}

.header-content {
  width: 100%;
  height: 10%;
  display: flex;
  justify-content: space-around;
  align-items: center;
}

.player-information {
  width: 25%;
  height: 80%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 10px;
  box-shadow: black 0 0 10px;
  display: flex;
  justify-content: space-around;
  align-items: center;
}

.player-picture {
  height: 80%;
  border: #3D3D3D 1px solid;
  border-radius: 10px;
}

.player-specs {
  display: flex;
  flex-direction: column;
  height: 80%;
  width: 60%;
  justify-content: space-around;
  align-items: center;
  overflow: hidden;
}

.player-name {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
  height: 50%;
  color: #c9c8c8;
}

.player-name-icon {
  height: 50%;
  margin-left: 15%;
  margin-right: 15%;
}

.player-id {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
  height: 50%;
  color: #c9c8c8;
}

.player-id-icon {
  height: 50%;
  margin-left: 15%;
  margin-right: 15%;
}



.server-name {
  width: 40%;
  height: 80%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 10px;
  box-shadow: black 0 0 10px;
  display: flex;
  justify-content: center;
  align-items: center;
}

#server-name-text {
  font-size: 3em;
  color: #c9c8c8;
}



.leave-information {
  width: 25%;
  height: 80%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 10px;
  box-shadow: black 0 0 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: transform 0.1s ease-out;
  perspective: 1000px;
}

.leave-information:hover {
  cursor: pointer;
}

.leave-icon {
  height: 50%;
  margin-right: 15%;
}

.leave-information p {
  font-size: 2em;
  color: #c9c8c8;
}




.body-content {
  width: 100%;
  height: 90%;
  display: flex;
  justify-content: flex-start;
  align-items: center;
}

.map-information {
  position: relative;
  width: 40%;
  height: 95.5%;
  background-image: url('./assets/map.png');
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
  border: #3D3D3D 3px solid;
  border-radius: 20px;
  box-shadow: black 0 0 10px;
  margin-left: 1.6%;
  filter: grayscale(1.0);
  transition: transform 0.1s ease-out;
  perspective: 1000px;
  overflow: hidden;
}

.map-information::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: black;
  opacity: 0.7;
  border-radius: inherit;
  z-index: 1;
}

.map-information:hover {
  cursor: pointer;
}

.map-information img {
  transition: transform 1s ease;
}

.map-information:hover img {
  transform: translateY(-30%);
}

.map-information:hover .info-box {
  transform: translateY(0);
  opacity: 1;
}



.list-infos {
  width: 25.3%;
  height: 95%;
  margin-left: 3.2%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
}

.rules-infos {
  width: 100%;
  height: 30%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 20px;
  box-shadow: black 0 0 10px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-bottom: 10%;
  transition: transform 0.1s ease-out;
  perspective: 1000px;
  overflow: hidden;
}

.rules-infos:hover {
  cursor: pointer;
}

.rules-infos img {
  transition: transform 1s ease;
}

.rules-infos:hover img {
  transform: translateY(-30%);
}

.info-box {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  background-color: #3D3D3D;
  text-align: center;
  padding: 2%;
  transform: translateY(100%);
  opacity: 0;
  transition: transform 1s ease, opacity 1s ease;
  z-index: 2;
}

.rules-infos:hover .info-box {
  transform: translateY(0);
  opacity: 1;
}

.info-box p {
  color: #fff;
  margin: 0;
  font-size: 1.1em;
}

.discord-infos {
  width: 100%;
  height: 30%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 20px;
  box-shadow: black 0 0 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 10%;
  transition: transform 0.1s ease-out;
  perspective: 1000px;
  overflow: hidden;
}

.discord-infos:hover {
  cursor: pointer;
}

.discord-infos img {
  transition: transform 1s ease;
}

.discord-infos:hover img {
  transform: translateY(-30%);
}

.discord-infos:hover .info-box {
  transform: translateY(0);
  opacity: 1;
}

.shopping-infos {
  width: 100%;
  height: 30%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 20px;
  box-shadow: black 0 0 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: transform 0.1s ease-out;
  perspective: 1000px;
  overflow: hidden;
}

.shopping-infos:hover {
  cursor: pointer;
}

.shopping-infos img {
  transition: transform 1s ease;
}

.shopping-infos:hover img {
  transform: translateY(-30%);
}

.shopping-infos:hover .info-box {
  transform: translateY(0);
  opacity: 1;
}

.rules-icon {
  height: 35%;
}

.discord-icon {
  height: 35%;
}

.shopping-icon {
  height: 35%;
}



.second-list-infos {
  width: 24.7%;
  height: 95%;
  margin-left: 3.3%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
}

.settings-infos {
  width: 100%;
  height: 67%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 20px;
  box-shadow: black 0 0 10px;
  margin-bottom: 10%;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: transform 0.1s ease-out;
  perspective: 1000px;
  overflow: hidden;
}

.settings-infos:hover {
  cursor: pointer;
}

.settings-infos img {
  transition: transform 1s ease;
}

.settings-infos:hover img {
  transform: translateY(-30%);
}

.settings-infos:hover .info-box {
  transform: translateY(0);
  opacity: 1;
}

.settings-icon {
  height: 35%;
}

.website-infos {
  width: 100%;
  height: 30.5%;
  background-color: #171717;
  border: #3D3D3D 3px solid;
  border-radius: 20px;
  box-shadow: black 0 0 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: transform 0.1s ease-out;
  perspective: 1000px;
  overflow: hidden;
}

.website-infos:hover {
  cursor: pointer;
}

.website-infos img {
  transition: transform 1s ease;
}

.website-infos:hover img {
  transform: translateY(-30%);
}

.website-infos:hover .info-box {
  transform: translateY(0);
  opacity: 1;
}

.website-icon {
  height: 35%;
}
</style>
