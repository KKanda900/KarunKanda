addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

/**
 * Respond with hello worker text
 * @param {Request} request
 */

//Request Handler
async function handleRequest(request) {
  
  //Part 1: "Request the URLs from the API"
  const url = await fetch("https://cfw-takehome.developers.workers.dev/api/variants")
  var jsonString
  if(url.ok){
    jsonString = (await url.json()) //This is an object similar in JAVA
  }

  //Part 2 & 3: "Request a (random: see #3) variant" and "Distribute requests between variants"
  return await fetch(jsonString.variants[Math.floor(Math.random()*jsonString.variants.length)])
}



