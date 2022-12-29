
function encodeCharAsBinary(v){
    const c = v.charCodeAt(0)
    return c.toString(2).padStart(5, "0") 
}

function encodeWordAsByteArray(word){
    return word.split("").map(encodeCharAsBinary) 
}

function encodeWord(word){
    const bytes = encodeWordAsByteArray(word.toUpperCase()).join('')
    return parseInt(bytes, 2)
}

function main(){
    const args = process.argv.slice(2)
    const guess = args[0]
    const challenge = args[1]

    console.log("guess: ", guess, encodeWord(guess))
    console.log("challenge: ", challenge, encodeWord(challenge))
}

main()
