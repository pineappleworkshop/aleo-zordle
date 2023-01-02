program hash.aleo;

function h:
    input r0 as u64.private; // v
    input r1 as u64.private; // s

    hash.psd8 r0 into r2;
    hash.psd8 r1 into r3;
    add r2 r3 into r4; 
    hash.psd8 r4 into r5;

    output r5 as field.private;
