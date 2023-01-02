import challenge.aleo;

program masked_challenge.aleo;

// masked challenge can be given to any user who wants to play.
// in order to "score" guesses, the original salt and word must be provided.
record masked_challenge:
    owner as address.public;
    gates as u64.public;
    hashed_word as field.public; // hash of encoded word & salt

function new:
    input r0 as challenge.aleo/challenge.record; 

    cast self.caller 0u64 r0.hashed_word into r1 as masked_challenge.record;

    output r1 as masked_challenge.record;

