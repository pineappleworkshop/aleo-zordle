import challenge.aleo;
import masked_challenge.aleo;
import segment.aleo;
import scored_guess.aleo;
import score.aleo;
import guess.aleo;
import hash.aleo;

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

// p1 scores guess
function score_guess:
    input r0 as challenge.aleo/challenge.record; // must provide original challenge
    input r1 as guess.aleo/guess.record;

    // challenge salt and word must be correct
    call hash.aleo/h r0.word r0.salt into r2; 
    //assert.eq r2 r1.hashed_word;

    call score.aleo/score r0.word r1.word into r3 r4 r5 r6 r7;

    // todo: replace with guess response
    call scored_guess.aleo/new r3 r4 r5 r6 r7 r1.player r0.hashed_word into r8;

    output r8 as scored_guess.aleo/scored_guess.record;
