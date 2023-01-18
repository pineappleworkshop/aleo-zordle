# Zordle (zk-wordle)

Based on the popular game, "wordle" (https://www.nytimes.com/games/wordle/index.html)

## Work in Progress!

_it is important to note that this app is merely a biproduct of a single developer's attempt at tackling zk-proofs and
and exploring the aleo platform, although playable, it is far from finished._

- Firstly, there is no game state. Unlike the original game, players can submit as many guesses as they like and there
is no logic for when the game is won. In future implementations, challengers' guess attempts will be restricted by some
owner specifed ruleset. Scoring will be based on how many attempts consumed before the win.

- Lacking contraints. Currently, it is possible to cheat the game in more ways than one. However, these exploits are
trivial to fix and certainly will be in future implementations.

- At some point, would love to pair this with reactle (https://reactle.vercel.app) an open-source wordle clone in react.
This would really bring zordle to life!

## Dependencies

- aleo instructions: https://developer.aleo.org/aleo/installation

- node (used for encoder.js): https://nodejs.org/en/download/

## Build

```bash
$ aleo build
```

## Game Logic

### Representing a Word as u64

Since Aleo Instructions doesn't support strings we can use bit packing to encode words as unsigned 64 bit integers.

The english alphabet supports 26 letters so we can use 5 bits per character: 2^5 = 32 

Let x be the ASCII encoding of a capital letter in the english alphabet. We can use the following to encode each letter
in our word: 
__f(x) = (x - 65) * 32 + x__

We can represent the binary representation of f(x) as b so that a word = {b_1,b_2,...,b_n}

__i.e. {A:1000001, B:1000010, C:1000011,..., Z:1011010}__

_take a look at encoder.js to see how this works in javascript_

Finally we can convert our byte array into u64 and use bitwise operations to compare and score words.

### Comparing u64 Words

Using the encoding mechanism outlined in the section above, we can split an encoded word into "segments" and compare
each segment of word 1 to each segment of word 2. Since loops are disallowed in Aleo Instructions, we can't have varying
word lengths, thus we enforce that each word had a length of 5 characters, just like in the original Wordle game.

Note: Leo _does_ support loops (https://developer.aleo.org/leo)

## Gameplay

A player creates a challenge with an secret word. Other players try to guess the word by submitting their own. With each 
guess, you're told which of your letters exist in the secret word, and if they are in the correct position.

### Guess Scoring

Guesses are scored with a set of enums, with one integer per character.

```
2: identical chars and indexes  
1: identical chars and different indexes  
0: neither
```

e.g.

```
challenge: first
guess:     fires
score:     {2,2,2,0,1}
```

and obviously a correct guess would be {2,2,2,2,2}

### Guide
<details><summary>Commands and Playing the Game</summary>

Let's create 2 new accounts, player 1 or p1 and p2 respectively. 
```bash
$ aleo account new

>>> Private Key  APrivateKey1zkp6f7VnWKFYQAmfBpjdgP1zVEq8YALgj382A5r9aVJ96hv
     View Key  AViewKey1o2KVZBVejnDpKq3pvXUYundnMpEWyWnRZEFpiFdQh5dU
      Address  aleo1kkjget0dry7jfp62sehr9zgeces2tjsmg2g05r4fewh7er67zsrq340sg9

$ aleo account new

>>> Private Key  APrivateKey1zkp6NzqcM3yniE2gJYYBkRgY9C9fuJThJ2nBk4qEH7foxZx
     View Key  AViewKey1sBKV8eoFcku6xdbY3RLSQy8ssS5Nhg5NapRaGK1TiawT
      Address  aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy
```

To start the game, p1 needs to create a challenge but first copy p1's creds into the program.json.

Next, we need to specify a 5-letter word for p2 to guess. since aleo instructions doesn't support strings, words are to be 
encoded as u64s with encoder.js. We can encode the word "first" like so:

```bash
$ node encoder.js first

>>> 18944928212
```

Now we can create a challenge with the encoded word, 18944928212 and salt, 12345678910.

```bash
# aleo run new_challenge <word_as_u64> <salt_u64>

$ aleo run new_challenge 18944928212u64 12345678910u64

>>> 🚀 Executing 'zordle.aleo/new_challenge'...

 • Executing 'zordle.aleo/new_challenge'...
 • Executed 'new' (in 2961 ms)
 • Executed 'new_challenge' (in 2799 ms)

⛓  Constraints

 •  'zordle.aleo/new_challenge' - 6,116 constraints (called 1 time)
 •  'challenge.aleo/new' - 3,451 constraints (called 1 time)

➡️  Output

 • {
  owner: aleo1kkjget0dry7jfp62sehr9zgeces2tjsmg2g05r4fewh7er67zsrq340sg9.private,
  gates: 0u64.private,
  word: 18944928212u64.private,
  salt: 12345678910u64.private,
  hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.public,
  _nonce: 6852080083275185335524946587899220983349760801550608508911166265335922765754group.public
}

✅ Executed 'zordle.aleo/new_challenge'
```

Next we have to create a player_challenge to issue to a specific player. _in future iterations this record will maintain 
game state_

```bash
# aleo run new_player_challenge <player_address> <challenge>

$ aleo run new_player_challenge aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy '{
    owner: aleo1kkjget0dry7jfp62sehr9zgeces2tjsmg2g05r4fewh7er67zsrq340sg9.private,
    gates: 0u64.private,
    word: 18944928212u64.private,
    salt: 12345678910u64.private,
    hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.public,
    _nonce: 6852080083275185335524946587899220983349760801550608508911166265335922765754group.public
  }'

>>> 🚀 Executing 'zordle.aleo/new_player_challenge'...

 • Executing 'zordle.aleo/new_player_challenge'...
 • Executed 'new' (in 3818 ms)
 • Executed 'new_player_challenge' (in 2936 ms)

⛓  Constraints

 •  'zordle.aleo/new_player_challenge' - 6,528 constraints (called 1 time)
 •  'player_challenge.aleo/new' - 1,767 constraints (called 1 time)

➡️  Output

 • {
  owner: aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy.private,
  gates: 0u64.private,
  challenge_owner: aleo1kkjget0dry7jfp62sehr9zgeces2tjsmg2g05r4fewh7er67zsrq340sg9.private,
  challenge_hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.private,
  started: false.private,
  _nonce: 3481084400866359650545221727166146597782877038147285643065323027486350168747group.public
}

✅ Executed 'zordle.aleo/new_player_challenge'
```

Now switch to p2 and create a guess.

Encode the word "fires"

```bash
$ node encoder.js fires

>>> 18944926419
```

and create a guess

```bash
# aleo run new_guess <word_as_u64> <player_challenge>

$ aleo run new_guess 18944926419u64 '{
    owner: aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy.private,
    gates: 0u64.private,
    challenge_owner: aleo1kkjget0dry7jfp62sehr9zgeces2tjsmg2g05r4fewh7er67zsrq340sg9.private,
    challenge_hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.private,
    started: false.private,
    _nonce: 3481084400866359650545221727166146597782877038147285643065323027486350168747group.public
  }'

>>> 🚀 Executing 'zordle.aleo/new_guess'...

 • Executing 'zordle.aleo/new_guess'...
 • Executed 'new' (in 3780 ms)
 • Executed 'new_guess' (in 2750 ms)

⛓  Constraints

 •  'zordle.aleo/new_guess' - 8,073 constraints (called 1 time)
 •  'guess.aleo/new' - 1,767 constraints (called 1 time)

➡️  Output

 • {
  owner: aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy.private,
  gates: 0u64.private,
  word: 18944926419u64.private,
  player: aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy.private,
  challenge_hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.private,
  _nonce: 1687757849842734156857555251586402038566590153110146825328971280357856360817group.public
}

✅ Executed 'zordle.aleo/new_guess'
```

Lastly, switch back to p1 and score the guess. 

```bash
# aleo run score_guess <challenge> <guess>

$ aleo run score_guess '{                                      
    owner: aleo1kkjget0dry7jfp62sehr9zgeces2tjsmg2g05r4fewh7er67zsrq340sg9.private,
    gates: 0u64.private,
    word: 18944928212u64.private,
    salt: 12345678910u64.private,
    hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.public,
    _nonce: 6852080083275185335524946587899220983349760801550608508911166265335922765754group.public
  }' '{
    owner: aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy.private,
    gates: 0u64.private,
    word: 18944926419u64.private,
    player: aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy.private,
    challenge_hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.private,
    _nonce: 1687757849842734156857555251586402038566590153110146825328971280357856360817group.public
  }'

>>> 🚀 Executing 'zordle.aleo/score_guess'...

 • Executing 'zordle.aleo/score_guess'...
 • Executed 'score_seg' (in 2472 ms)
 • Executed 'score_seg' (in 2604 ms)
 • Executed 'score_seg' (in 2582 ms)
 • Executed 'score_seg' (in 2615 ms)
 • Executed 'score_seg' (in 2651 ms)
 • Executed 'new' (in 5072 ms)
 • Executed 'score_guess' (in 7837 ms)

⛓  Constraints

 •  'zordle.aleo/score_guess' - 41,594 constraints (called 1 time)
 •  'scored_guess.aleo/new' - 1,767 constraints (called 1 time)
 •  'segment.aleo/score_seg' - 100 constraints (called 5 times)

➡️  Output

 • {
  owner: aleo1y8jref9s6feavph9925tscwmepzvtrrm3gfemlxe0reezh0j4yys3lvmyy.private,
  gates: 0u64.private,
  challenge_hashed_word: 1865907154771461922856548023738717803892127058468460638208821005521755648577field.private,
  word: 18944926419u64.private,
  matches: {
    a0: 2u8.private,
    a1: 2u8.private,
    a2: 2u8.private,
    a3: 0u8.private,
    a4: 1u8.private
  },
  _nonce: 7022066428292202633173405816835887447571148816178631511292787441218777754077group.public
}
```

score: {2,2,2,0,1} (see "Guess Scoring" for more info)

_although the game doesn't currently maintain state, p2 might continue by guessing again with the information they were
given. eventually, the correct answer will yield a score of {2,2,2,2,2}_

### Why Aleo?

#### 01/18/23

__Aleo__

Privacy, speed, and decentralization are common platitudes of seemingly all new blockchain systems today. Unfortunately,
in this space it is far too common to overpromise and underdeliver. Often chains prioritize one of these pillars
while compromising another - all in the interest of development efficacy. However, I believe that Aleo differs from many
chains in a unique way. __Aleo's protocol uses zero knowledge cryptography and zero knowledge proofs enabling transactions
to be run trustlessly off chain, laying out the groundwork to intuitively build into privacy, speed, and 
decentralization__. Meaning that Aleo can be developed uncompromisingly - provided that their protocol is scalable.

__Development__

In an effort to understand the fundamentals of Aleo, I opted to work with Aleo Instructions rather than their high level 
language, Leo. Now, I can't speak to Leo becuase I'm unfamiliar but I'd probably recommend starting there instead.
Development with Aleo Instructions is difficult, syntactically, conceptually, and otherwise. 

Typical disadvantages of level languages aside, the docs are outtdated and sparse leading to a significant amount of 
development time wasted on trial and error. At the time of writing this, some of the docs are incorrect as the 
language is changing rapidly. For example, "interface" was changed to "struct" at some point, causing quite a bit of 
confusion.

Logic in Aleo is written with circuits, which is dissimilar to other paradigms I've worked with. I won't go into
details about them but here's a good article: 
https://medium.com/web3studio/simple-explanations-of-arithmetic-circuits-and-zero-knowledge-proofs-806e59a79785 

Aleo Instructions doesn't represent arrays or strings well yet, nor does it support for/while loops. Meaning, you often have to
get creative when working with characters. See "Game Logic" above for an example.

__Testnet__

At the time of this writing, the Testnet isn't publicly available. So, I can't speak to committing/querying records. 

__Conclusion__

Aleo might be the first chain to successfully implement privacy and speed while maintaining decetralization; however, 
In alignment with a conversation we had with some of their team, I believe that learning development on Aleo is a 
significant undertaking that may be difficult to monetize in the short term but could reap serious rewards in the long -
especially once the team gets closer to a Mainnet deployment.
