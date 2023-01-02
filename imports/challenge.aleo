program challenge.aleo;

record challenge:
    owner as address.private;
    gates as u64.private;
    word as u64.private;
    salt as u64.private;
    hashed_word as field.private;

closure h:
    input r0 as u64; // v
    input r1 as u64; // s

    hash.psd8 r0 into r2;
    hash.psd8 r1 into r3;
    add r2 r3 into r4; 
    hash.psd8 r4 into r5;

    output r5 as field;

function new:
    input r0 as u64.private; // word 
    input r1 as u64.private; // salt

    call h r0 r1 into r2; 

    cast self.caller 0u64 r0 r1 r2 into r3 as challenge.record;
    
    output r3 as challenge.record;
