'reach 0.1';

const Player = {
    getHand: Fun([], UInt),
    seeOutcome: Fun([UInt], Null),
};

export const main = Reach.App(() => {
    const Alice = Participant('Alice', {
        ...Player,
        wager: UInt,
    });
    const Bob = Participant('Bob', {
        ...Player,
        acceptWager: Fun([UInt], Null),
    });
    init();
    
    Alice.only(() => {
        const wager = declassify(interact.wager);
        const handAlice = declassify(interact.getHand());
    });
    Alice.publish(wager, handAlice)
        .pay(wager);
    commit();

    Bob.only(() => {
        const handBob = declassify(interact.getHand());
    });
    Bob.publish(handBob);

    const outcome = (handAlice + (4 - handBob)) % 3;
    commit();

    each([Alice, Bob], () => {
        interact.seeOutcome(outcome);
    });
});