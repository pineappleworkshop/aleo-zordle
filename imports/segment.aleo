program segment.aleo;

// since Aleo Instructions doesn't support strings we can use bit packing to 
// encode words as unsigned 64 bit integers.
//
// the english alphabet supports 26 letters so we can use 5 bits per character: 2^5 = 32 
//
// let x be the ASCII encoding of a capital letter in the english alphabet.
// we can use the following to encode each letter in our word: f(x) = (x - 65) * 32 + x
// we can represent the binary representation of f(x) as b so that a word w = {b_1,b_2,...,b_5}
// 
// i.e. {A:1100001, B:1100010, C:1100011,..., Z:1111010}
// 
// finally we can convert our byte array into u64 and perform bitwise operations to compare words

// ascii encoded array of segments or "segs"
struct segs:
    a0 as u64;
    a1 as u64;
    a2 as u64;
    a3 as u64;
    a4 as u64;

// helper function to compare "segments" consisting
// of an ascii encoded character and an index.
//
// returns a "score"
// 2, identical chars and indexes | 
// 1, identical chars and different indexes | 
// 0, neither
//
closure compare_segs:
    input r0 as u64; // char 1 c_1
    input r1 as u64; // char 2 c_2
    input r2 as u8;  // index of c_1
    input r3 as u8;  // index of c_2

    is.eq r0 r1 into r4;
    is.eq r2 r3 into r5;
    and r4 r5 into r6;

    ternary r4 1u8 0u8 into r7;
    ternary r6 2u8 r7 into r8;

    output r8 as u8;

// find seg in array.
// also returns a "score" (see compare_segs)
function score_seg:
    input r0 as u64.private;  // guess character c
    input r1 as u8.private;   // index of c
    input r2 as segs.private; // challenge word segs

    call compare_segs r0 r2.a0 r1 0u8 into r3;
    call compare_segs r0 r2.a1 r1 1u8 into r4;
    call compare_segs r0 r2.a2 r1 2u8 into r5;
    call compare_segs r0 r2.a3 r1 3u8 into r6;
    call compare_segs r0 r2.a4 r1 4u8 into r7;

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
