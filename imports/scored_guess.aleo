program scored_guess.aleo;

struct matches:
    a0 as u8;
    a1 as u8;
    a2 as u8;
    a3 as u8;
    a4 as u8;

record scored_guess:
    owner as address.private; // player
    gates as u64.private;
    challenge_hashed_word as field.private;
    word as u64.private;
    matches as matches.private;

// todo: clean up
function new:
    input r0 as u8.private;
    input r1 as u8.private;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as u8.private;

    input r5 as address.private; // owner
    input r6 as field.private; // challenge hashed word
    input r7 as u64.private; // guess word

    cast r0 r1 r2 r3 r4 into r8 as matches;
    cast r5 0u64 r6 r7 r8 into r9 as scored_guess.record;

    output r9 as scored_guess.record;
