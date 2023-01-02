program guess.aleo;

record guess:
    owner as address.private; // challenge owner
    gates as u64.private;
    word as u64.private;
    player as address.private;
    hashed_word as field.private;

function new:
    input r0 as u64.private; // word 
    input r1 as field.private; // hashed word
    input r2 as address.private; // challenge owner

    cast r2 0u64 r0 self.caller r1 into r3 as guess.record;
    
    output r3 as guess.record;
