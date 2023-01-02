import challenge.aleo;
import masked_challenge.aleo;
import scored_guess.aleo;
import segment.aleo;
//import score.aleo;
import guess.aleo;

program sandbox.aleo;

struct matches:
    a0 as u8;
    a1 as u8;
    a2 as u8;
    a3 as u8;
    a4 as u8;

// p1 challenge
function new_challenge:
    input r0 as u64.private; // encoded word guess g
    input r1 as u64.private; // salt s

    call challenge.aleo/new r0 r1 into r2;
    call masked_challenge.aleo/new r2 into r3;

    output r2 as challenge.aleo/challenge.record; // keep secret
    output r3 as masked_challenge.aleo/masked_challenge.record; // give to p2

// p2 guess
function new_guess:
    input r0 as u64.private; // encoded word guess g
    input r1 as masked_challenge.aleo/masked_challenge.record;

    call guess.aleo/new r0 r1.hashed_word r1.owner into r2;

    output r2 as guess.aleo/guess.record;

struct segs:
    a0 as u64;
    a1 as u64;
    a2 as u64;
    a3 as u64;
    a4 as u64;

// perform bitwise operations to split u64 into ascii array of "segs"
closure u64_to_segs:
    input r0 as u64;

    // index 0, 4
    shl r0 28u8 into r1;
    and r0 127u64 into r2;

    // index 1
    shl r0 21u8 into r3;
    and r3 127u64 into r4;

    // index 2
    shl r0 14u8 into r5;
    and r5 127u64 into r6;

    // index 3
    shl r0 7u8 into r7;
    and r7 127u64 into r8;

    cast r1 r4 r6 r8 r2 into r9 as segs;

    output r9 as segs;

closure segs_to_u64:
    input r0 as segs;
    
    shl r0.a0 32u8 into r1;
    shl r0.a1 24u8 into r2;
    and r1 r2 into r3;
    shl r0.a2 16u8 into r4;
    and r3 r4 into r5;
    shl r0.a3 8u8 into r6;
    and r5 r6 into r7;
    and r7 r0.a4 into r8;

    output r8 as u64;

closure h:
    input r0 as u64; // v
    input r1 as u64; // s

    hash.psd8 r0 into r2;
    hash.psd8 r1 into r3;
    add r2 r3 into r4; 
    hash.psd8 r4 into r5;

    output r5 as field;

// p1 scores guess
function score_guess:
    input r0 as challenge.aleo/challenge.record; // must provide original challenge
    input r1 as guess.aleo/guess.record;

    // challenge salt and word must be correct
    // call h r0.word r0.salt into r2; 
    // assert.eq r2 r1.hashed_word;

    // decode to array of ascii encoded vals
    call u64_to_segs r0.word into r2;
    call u64_to_segs r1.word into r3;

    call segment.aleo/score_seg r2.a0 0u8 r3 into r4;
    call segment.aleo/score_seg r2.a1 1u8 r3 into r5;
    call segment.aleo/score_seg r2.a2 2u8 r3 into r6;
    call segment.aleo/score_seg r2.a3 3u8 r3 into r7;
    call segment.aleo/score_seg r2.a4 4u8 r3 into r8;

    cast r4 r5 r6 r7 r8 into r9 as segs;

    output r9 as segs.private;
