import hash.aleo;

program challenge.aleo;

record challenge:
    owner as address.private;
    gates as u64.private;
    word as u64.private;
    salt as u64.private;
    hashed_word as field.private;

function new:
    input r0 as u64.private; // word 
    input r1 as u64.private; // salt

    call hash.aleo/h r0 r1 into r2; 

    cast self.caller 0u64 r0 r1 r2 into r3 as challenge.record;
    
    output r3 as challenge.record;
