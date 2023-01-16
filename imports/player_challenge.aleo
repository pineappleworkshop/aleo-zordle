import challenge.aleo;

program player_challenge.aleo;

// player challenge can be given to any user who wants to play.
// in order to "score" guesses, the original salt and word must be provided.
record player_challenge:
    owner as address.private; // p2
    gates as u64.private;
    challenge_owner as address.private;
    challenge_hashed_word as field.private; 
    started as boolean.private;

function new:
    input r0 as address.private;
    input r1 as field.private;

    cast r0 0u64 self.caller r1 false into r2 as player_challenge.record;

    output r2 as player_challenge.record;
