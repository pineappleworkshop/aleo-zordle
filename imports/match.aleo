import wordle.aleo;

program find.aleo;

// find byte in a byte array
//
// returns
// 2, identical chars and indexes | 
// 1, identical chars and different indexes | 
// 0, neither
//
function find_byte:
    input r0 as u64.private;  // guess character c
    input r1 as u8.private;   // index of c
    input r2 as word.private; // challenge word

    call compare_chars r0 r2.a0 r1 0u8 into r3;
    call compare_chars r0 r2.a1 r1 1u8 into r4;
    call compare_chars r0 r2.a2 r1 2u8 into r5;
    call compare_chars r0 r2.a3 r1 3u8 into r6;
    call compare_chars r0 r2.a4 r1 4u8 into r7;

    // get the max value
    gt r3 0u8 into r8;
    ternary r8 r3 0u8 into r9;
    gt r4 r9 into r10;
    ternary r10 r4 r9 into r11;
    gt r5 r11 into r12;
    ternary r12 r5 r11 into r13;
    gt r6 r13 into r14;
    ternary r14 r6 r13 into r15;
    gt r7 r15 into r16;
    ternary r16 r7 r15 into r17;

    output r17 as u8.private;
