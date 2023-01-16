import challenge.aleo;
import player_challenge.aleo;
import segment.aleo;
import scored_guess.aleo;
import guess.aleo;

program sandbox.aleo;

// NOTE
// encoding words as u64s to be split into segments or "segs" will help keep the code - and records - neat

// in aleo instructions, any/all referenced structs need to be declared explicitly
// segments.aleo
struct segs:
    a0 as u64;
    a1 as u64;
    a2 as u64;
    a3 as u64;
    a4 as u64;

// scored_guess.aleo
struct matches:
    a0 as u8;
    a1 as u8;
    a2 as u8;
    a3 as u8;
    a4 as u8;

// perform bitwise operations to split u64 into ascii array of "segs"
closure u64_to_segs:
    input r0 as u64;

    // index 0, 4
    shr r0 28u8 into r1;
    and r0 127u64 into r2;

    // index 1
    shr r0 21u8 into r3;
    and r3 127u64 into r4;

    // index 2
    shr r0 14u8 into r5;
    and r5 127u64 into r6;

    // index 3
    shr r0 7u8 into r7;
    and r7 127u64 into r8;

    cast r1 r4 r6 r8 r2 into r9 as segs;

    output r9 as segs;

// p1 creates challenge - not to be given to p2
function new_challenge:
    input r0 as u64.private; // encoded word guess g
    input r1 as u64.private; // salt s

    call challenge.aleo/new r0 r1 into r2;

    output r2 as challenge.aleo/challenge.record;

// p1 creates player challenge for p2
function new_player_challenge:
    input r0 as address.private; // p2
    input r1 as challenge.aleo/challenge.record; // challenge

    call player_challenge.aleo/new r0 r1.hashed_word into r2;

    output r2 as player_challenge.aleo/player_challenge.record; // give to p2

// p2 guess
function new_guess:
    input r0 as u64.private; // encoded word guess g
    input r1 as player_challenge.aleo/player_challenge.record;

    call guess.aleo/new r0 r1.challenge_hashed_word r1.owner into r2;

    output r2 as guess.aleo/guess.record;

// helper hashing function
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
    call h r0.word r0.salt into r2; 
    assert.eq r2 r1.challenge_hashed_word;

    // decode to array of ascii encoded vals
    call u64_to_segs r0.word into r3;
    call u64_to_segs r1.word into r4;

    call segment.aleo/score_seg r3.a0 0u8 r4 into r5;
    call segment.aleo/score_seg r3.a1 1u8 r4 into r6;
    call segment.aleo/score_seg r3.a2 2u8 r4 into r7;
    call segment.aleo/score_seg r3.a3 3u8 r4 into r8;
    call segment.aleo/score_seg r3.a4 4u8 r4 into r9;

    // todo: replace with guess response
    call scored_guess.aleo/new r5 r6 r7 r8 r9 r1.player r0.hashed_word r1.word into r10;

    output r10 as scored_guess.aleo/scored_guess.record;

// testing only: score word w 1 and 2
function score_words:
    input r0 as u64.private; // w1
    input r1 as u64.private; // w2

    call u64_to_segs r0 into r2;
    call u64_to_segs r1 into r3;

    call segment.aleo/score_seg r2.a0 0u8 r3 into r4;
    call segment.aleo/score_seg r2.a1 1u8 r3 into r5;
    call segment.aleo/score_seg r2.a2 2u8 r3 into r6;
    call segment.aleo/score_seg r2.a3 3u8 r3 into r7;
    call segment.aleo/score_seg r2.a4 4u8 r3 into r8;

    output r4 as u8.private;
    output r5 as u8.private;
    output r6 as u8.private;
    output r7 as u8.private;
    output r8 as u8.private;

