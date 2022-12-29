import segment.aleo;

program sandbox.aleo;

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

function score:
    input r0 as u64.private; // guess
    input r1 as u64.private; // challenge

    // decode to array of ascii encoded vals
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

