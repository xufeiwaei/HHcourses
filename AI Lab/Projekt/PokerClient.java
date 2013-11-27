/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.*;
import java.util.Random;
import java.util.Vector;

/**
 * A class acting as a poker client. It extends the base class {@link PokerClientBase}
 * and is intended to be reviewed and/or changed by students.
 * @author Tobias Persson
 */
public class PokerClient extends PokerClientBase {

    private HandEvaluator _handEval;

    private final static int unknown = -1;
    private final static int strflush = 9;
    private final static int quads = 8;
    private final static int fullhouse = 7;
    private final static int flush = 6;
    private final static int straight = 5;
    private final static int trips = 4;
    private final static int twopair = 3;
    private final static int pair = 2;
    private final static int nopair = 1;
    private final static int highcard = 1;

    /**
     * Upper limit for _nrTimesRaised.
     */
    private final int MAX_NR_RAISE = 2;

    private final static int BAD_HAND = 0;
    private final static int MEDIUM_HAND = 1;
    private final static int NORMAL_HAND = 2;
    private final static int GOOD_HAND = 3;
    private final static int VERY_GOOD_HAND = 4;

    private final static int BAD_RANK = 149747;
    private final static int MEDIUM_RANK = 306649;
    private final static int NORMAL_RANK = 379854;
    private final static int GOOD_RANK = 388853;
    private final static int VERY_GOOD_RANK = 397626;


    private Random _random = new Random();

    /**
     * Current hand.
     */
    private Hand _hand;

    /**
     * The name of our poker agent.
     */
    private String _name;

    /**
     * Amount of chips we currently have.
     */
    private int _chips;

    /**
     * The current round number.
     */
    private int _roundNr;

    /**
     * The current value of ante.
     */
    private int _curAnte;

    /**
     * Tracks the number of times we raised this round.
     */
    private int _nrTimesRaised;

    /**
     * Keep track of the poker game actions.
     */
    private final PokerGame _pokerGame;

    /**
     * Creates a new instance of <code>PokerClient</code>.
     * @param server    the address of the poker server.
     * @param port      the port used by the poker server.
     */
    public PokerClient(String server, int port) {
        super(server, port);

        _handEval = new HandEvaluator();
        _pokerGame = new PokerGame();
    }

    /**
     * Gets the name of the player.
     * @return  The name of the player as a single word without space. <code>null</code> is not a valid answer.
     */
    protected String queryPlayerName() {
        // NOTE
        // You typically return a constant (final) string here, not something
        // generated dynamically and/or randomly as is done now. This is only
        // to give different clients different names during testing.
        if (_name == null) {
            _name = "DryAce";
        }
        return _name;
    }

    /**
     * Called when a new round begins.
     * @param round the round number (increased for each new round).
     */
    protected void infoNewRound(int round) {
        _roundNr = round;
        _nrTimesRaised = 0;

        _pokerGame.newRound();

        notifyTextReceivers("Starting round #" + round);
    }

    /**
     * Called when the poker server informs that the game is completed.
     */
    protected void infoGameOver() {
        // Cleanup??
        notifyTextReceivers("The game is over.");
    }

    /**
     * Called when the server informs the players how many chips a player has.
     * @param playerName    the name of a player.
     * @param chips         the amount of chips the player has.
     */
    protected void infoPlayerChips(String playerName, int chips) {
        // Must happen only once
        _pokerGame.currentRound().initPlayer(playerName);
        _pokerGame.currentRound().setPlayerChips(playerName, chips);
        notifyTextReceivers("The player '" + playerName + "' has " + chips + " chips.");
    }

    /**
     * Called when the ante has changed.
     * @param ante  the new value of the ante.
     */
    protected void infoAnteChanged(int ante) {
        _pokerGame.currentRound().setCurrentAnte(ante);
        notifyTextReceivers("The ante is " + ante);
    }

    /**
     * Called when a player had to do a forced bet (putting the ante in the pot).
     * @param playerName    the name of the player forced to do the bet.
     * @param forcedBet     the number of chips forced to bet.
     */
    protected void infoForcedBet(String playerName, int forcedBet) {
        _pokerGame.currentRound().setPlayerChips(playerName,
            _pokerGame.currentRound().getPlayerChips(playerName) - forcedBet);

        _pokerGame.currentRound().addToPot(forcedBet);

        notifyTextReceivers("Player " + playerName + " made a forced bet of " + forcedBet + " chips.");
    }

    /**
     * Called when a player opens a betting round.
     * @param playerName        the name of the player that opens.
     * @param openBet           the amount of chips the player has put into the pot.
     */
    protected void infoPlayerOpen(String playerName, int openBet) {
        _pokerGame.currentRound().setPlayerChips(playerName,
            _pokerGame.currentRound().getPlayerChips(playerName) - openBet);

        _pokerGame.currentRound().addToPot(openBet);

        notifyTextReceivers("Player " + playerName + " opened, has put " + openBet + " chips into the pot.");
    }

    /**
     * Called when a player checks.
     * @param playerName        the name of the player that checks.
     */
    protected void infoPlayerCheck(String playerName) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setNrTimesChecked(ri.getNrTimesChecked() + 1);
        notifyTextReceivers("Player " + playerName + " checked.");
    }

    /**
     * Called when a player raises.
     * @param playerName        the name of the player that raises.
     * @param amountRaisedTo    the amount of chips the player raised to.
     */
    protected void infoPlayerRaise(String playerName, int amountRaisedTo) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setNrTimesRaised(ri.getNrTimesRaised() + 1);
        ri.addRaise(amountRaisedTo);

        _pokerGame.currentRound().addToPot(amountRaisedTo);
        _pokerGame.currentRound().setLastRaise(amountRaisedTo);

        notifyTextReceivers("Player " + playerName + " raised to " + amountRaisedTo + " chips.");
    }

    /**
     * Called when a player calls.
     * @param playerName        the name of the player that calls.
     */
    protected void infoPlayerCall(String playerName) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setNrTimesCalled(ri.getNrTimesCalled() + 1);
        _pokerGame.currentRound().addToPot(_pokerGame.currentRound().getLastRaise());
        notifyTextReceivers("Player " + playerName + " called.");
    }

    /**
     * Called when a player folds.
     * @param playerName        the name of the player that folds.
     */
    protected void infoPlayerFold(String playerName) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setFold(true);
        notifyTextReceivers("Player " + playerName + " folded.");
    }

    /**
     * Called when a player goes all-in.
     * @param playerName        the name of the player that goes all-in.
     * @param allInChipCount    the amount of chips the player has in the pot and goes all-in with.
     */
    protected void infoPlayerAllIn(String playerName, int allInChipCount) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setAllIn(true);

        _pokerGame.currentRound().addToPot(allInChipCount);
        _pokerGame.currentRound().setLastRaise(allInChipCount);

        notifyTextReceivers("Player " + playerName + " goes all-in with a pot of " + allInChipCount + " chips.");
    }

    /**
     * Called when a player has exchanged (thrown away and drawn new) cards.
     * @param playerName        the name of the player that has exchanged cards.
     * @param cardCount         the number of cards exchanged.
     */
    protected void infoPlayerDraw(String playerName, int cardCount) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setNrCardsDrawn(cardCount);
        notifyTextReceivers("Player " + playerName + " exchanged " + cardCount + " cards.");
    }

    /**
     * Called during the showdown when a player shows his hand.
     * @param playerName        the name of the player whose hand is shown.
     * @param hand              the players hand.
     */
    protected void infoPlayerHand(String playerName, Hand hand) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setHand(hand);
        notifyTextReceivers("Player " + playerName + " has this hand:" + hand + " (" + getHandName(hand) + ", category #" + getHandCategory(hand) + ")");
    }

    /**
     * Called during the showdown when a players undisputed win is reported.
     * @param playerName    the name of the player whose undisputed win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundUndisputedWin(String playerName, int winAmount) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setRoundWinAmount(winAmount);
        ri.setUndisputedWin(true);
        notifyTextReceivers("Player " + playerName + " won " + winAmount + " chips undisputed.");
    }

    /**
     * Called during the showdown when a players win is reported. If a player does not win anything,
     * this method is not called.
     * @param playerName    the name of the player whose win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundResult(String playerName, int winAmount) {
        RoundInfo ri = _pokerGame.currentRound().getRoundInfo(playerName);
        ri.setRoundWinAmount(winAmount);
        ri.setUndisputedWin(false);
        notifyTextReceivers("Player " + playerName + " won " + winAmount + " chips.");
    }

    /**
     * Called during the betting phases of the game when the player needs to decide what open
     * action to choose.
     * @param minimumPotAfterOpen   the total minimum amount of chips to put into the pot if the answer action is
     *                              {@link BettingAnswer#ACTION_OPEN}.
     * @param playersCurrentBet     the amount of chips the player has already put into the pot (dure to the forced bet).
     * @param playersRemainingChips the number of chips the player has not yet put into the pot.
     * @return                      An answer to the open query. The answer action must be one of
     *                              {@link BettingAnswer#ACTION_OPEN}, {@link BettingAnswer#ACTION_ALLIN} or
     *                              {@link BettingAnswer#ACTION_CHECK }. If the action is open, the answers
     *                              amount of chips in the anser must be between <code>minimumPotAfterOpen</code>
     *                              and the players total amount of chips (the amount of chips alrady put into
     *                              pot plus the remaining amount of chips).
     */
    protected BettingAnswer queryOpenAction(int minimumPotAfterOpen, int playersCurrentBet, int playersRemainingChips) {
        notifyTextReceivers("Player requested to choose an opening action.");

        int handCategory = getHandCategory(_hand);

        int raiseAmount = 10;
        double rr = calcRateOfReturn(raiseAmount);

        switch (handCategory) {
            case BAD_HAND:
            case MEDIUM_HAND:
            case NORMAL_HAND:
                return new BettingAnswer(BettingAnswer.ACTION_CHECK);

            case GOOD_HAND:
            case VERY_GOOD_HAND:
                if (minimumPotAfterOpen + raiseAmount > playersRemainingChips) {
                    return new BettingAnswer(BettingAnswer.ACTION_CHECK);
                }

                return new BettingAnswer(BettingAnswer.ACTION_OPEN, minimumPotAfterOpen + raiseAmount);

            default:
                notifyTextReceivers("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx.");
                return new BettingAnswer(BettingAnswer.ACTION_CHECK);
        }
    }

    /**
     * Called when the player receives cards. The hand contains all cards the player currently holds.
     * @param hand  the hand of cards the player currently holds.
     */
    protected void infoCardsInHand(Hand hand) {
        _hand = hand;
        notifyTextReceivers("The cards in hand is" + hand + ".");
    }

    protected int getHandCategory(Hand hand) {
        int handRank = HandEvaluator.rankHand(hand);

        if (handRank >= BAD_RANK && handRank < MEDIUM_RANK) return BAD_HAND;
        else if (handRank >= MEDIUM_RANK && handRank < NORMAL_RANK) return MEDIUM_HAND;
        else if (handRank >= NORMAL_RANK && handRank < GOOD_RANK) return NORMAL_HAND;
        else if (handRank >= GOOD_RANK && handRank < VERY_GOOD_RANK) return GOOD_HAND;
        else if (handRank >= VERY_GOOD_RANK) return VERY_GOOD_HAND;

        notifyTextReceivers("BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD");
        // Should never reach
        return BAD_HAND;
    }

    /**
     * Called during the betting phases of the game when the player needs to decide what call/raise
     * action to choose.
     * @param maximumBet                the maximum number of chips one player has already put into the pot.
     * @param minimumAmountToRaiseTo    the minimum amount of chips to bet if the returned answer is {@link BettingAnswer#ACTION_RAISE}.
     * @param playersCurrentBet         the number of chips the player has already put into the pot.
     * @param playersRemainingChips     the number of chips the player has not yet put into the pot.
     * @return                          An answer to the call or raise query. The answer action must be one of
     *                                  {@link BettingAnswer#ACTION_FOLD}, {@link BettingAnswer#ACTION_CALL},
     *                                  {@link BettingAnswer#ACTION_RAISE} or {@link BettingAnswer#ACTION_ALLIN }.
     *                                  If the players number of remaining chips is less than the maximum bet and
     *                                  the players current bet, the call action is not available. If the players
     *                                  number of remaining chips plus the players current bet is less than the minimum
     *                                  amount of chips to raise to, the raise action is not available. If the action
     *                                  is raise, the answers amount of chips is the total amount of chips the player
     *                                  puts into the pot and must be between <code>minimumAmountToRaiseTo</code> and
     *                                  <code>playersCurrentBet+playersRemainingChips</code>.
     */
    protected BettingAnswer queryCallRaiseAction(int maximumBet, int minimumAmountToRaiseTo, int playersCurrentBet, int playersRemainingChips) {
        notifyTextReceivers("Player requested to choose a call/raise action.");

        int handCategory = getHandCategory(_hand);

        int raiseAmount = 10;
        double rr = calcRateOfReturn(raiseAmount);

        switch (handCategory) {
            case BAD_HAND:
                return new BettingAnswer(BettingAnswer.ACTION_FOLD);

            case MEDIUM_HAND:
                return new BettingAnswer(BettingAnswer.ACTION_CALL);

            case NORMAL_HAND:
            case GOOD_HAND:
            case VERY_GOOD_HAND:

                // If RR < 0.8 then 95% fold, 0 % call, 5% raise (bluff)
                // If RR < 1.0 then 80%, fold 5% call, 15% raise (bluff)
                // If RR <1.3 the 0% fold, 60% call, 40% raise
                // Else (RR >= 1.3) 0% fold, 30% call, 70% raise
                // If fold and amount to call is zero, then call.

                if (_nrTimesRaised++ > MAX_NR_RAISE)
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);

                if (minimumAmountToRaiseTo + raiseAmount > playersRemainingChips) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                }

                if (playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                    return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + raiseAmount);
                }

                return new BettingAnswer(BettingAnswer.ACTION_CALL);

            default:
                notifyTextReceivers("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY.");
                return new BettingAnswer(BettingAnswer.ACTION_FOLD);
        }
    }

    /**
     * Called during the draw phase of the game when the player is offered to throw away some
     * (possibly all) of the cards on hand in exchange for new.
     * @return  An array of the cards on hand that should be thrown away in exchange for new,
     *          or <code>null</code> or an empty array to keep all cards.
     * @see     #infoCardsInHand(ca.ualberta.cs.poker.Hand)
     */
    protected Card[] queryCardsToThrow() {
        // Determine current hand and into what we'll change
        notifyTextReceivers("Requested information about what cards to throw");

        return determineCardsToThrow();
    }

    private Card[] determineCardsToThrow() {
        // Don't forget INCOMPLETE flush and straight
        String handStr = HandEvaluator.nameHand(_hand);


        if (handStr.indexOf("a Pair") != -1) {
            return determineCardsToThrowPair();
        } else if (handStr.indexOf("Two Pair") != -1) {
            return determineCardsToThrowTwoPair();
        } else if (handStr.indexOf("Three of a Kind") != -1) {
            return determineCardsToThrowTrips();
        } else if (handStr.indexOf("High Straight") != -1) {
            return throwZeroCards();
        } else if (handStr.indexOf("a Flush") != -1) {
            return throwZeroCards();
        } else if (handStr.indexOf("a Full House") != -1) {
            return throwZeroCards();
        } else if (handStr.indexOf("Four of a Kind") != -1) {
            return throwZeroCards();
        } else if (handStr.indexOf("High Straight Flush") != -1) {
            return throwZeroCards();
        } else if (handStr.indexOf("High") != -1) {
            return determineCardsToThrowHighcard();
        }

        notifyTextReceivers("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ.");

        return throwZeroCards();
    }

    private Card[] determineCardsToThrowHighcard() {
        int [] cards = _hand.getCardArray();
        Vector cardsToThrow = new Vector();

        for (int i = 1; i <= cards[0]; i++) {
            Card c = _hand.getCard(i);
            if (c.getRank() == Card.QUEEN ||
                c.getRank() == Card.KING ||
                c.getRank() == Card.ACE) {
                continue;
            }
            cardsToThrow.addElement(c);
        }

        return cardVectorToArray(cardsToThrow);
    }

    private Card[] determineCardsToThrowPair() {
        int [] cards = _hand.getCardArray();
        Vector cardsToThrow = new Vector();
        Card [] mypair = new Card[2];

        for (int i = 1; i <= cards[0]; i++) {
            Card c1 = _hand.getCard(i);
            for (int j = 1; j <= cards[0]; j++) {
                if (i == j) continue; // skip same card

                Card c2 = _hand.getCard(j);
                if (c1.getRank() == c2.getRank()) {
                    mypair[0] = c1;
                    mypair[1] = c2;
                    break;
                }
            }
        }

        for (int i = 1; i <= cards[0]; i++) {
            Card c = _hand.getCard(i);
            if (mypair[0].getRank() != c.getRank() &&
                mypair[1].getRank() != c.getRank()) {
                cardsToThrow.addElement(c);
            }
        }

        return cardVectorToArray(cardsToThrow);
    }

    private Card[] determineCardsToThrowTwoPair() {
        int [] cards = _hand.getCardArray();
        Card [] cardsToThrow = new Card[1];

        for (int i = 1; i <= cards[0]; i++) {
            Card c1 = _hand.getCard(i);
            boolean unique = true;

            for (int j = 1; j <= cards[0]; j++) {
                if (i == j) continue; // skip same card

                Card c2 = _hand.getCard(j);
                if (c1.getRank() == c2.getRank()) {
                    unique = false;
                }
            }

            if (unique) {
                cardsToThrow[0] = c1;
                break;
            }
        }

        return cardsToThrow;
    }

    private Card[] determineCardsToThrowTrips() {
        int [] cards = _hand.getCardArray();
        Card [] cardsToThrow = new Card[2];
        int cardToThrowIndex = 0;

        for (int i = 1; i <= cards[0]; i++) {
            Card c1 = _hand.getCard(i);
            boolean unique = true;

            for (int j = 1; j <= cards[0]; j++) {
                if (i == j) continue; // skip same card

                Card c2 = _hand.getCard(j);
                if (c1.getRank() == c2.getRank()) {
                    unique = false;
                }
            }

            if (unique) {
                cardsToThrow[cardToThrowIndex++] = c1;
            }
        }

        return cardsToThrow;
    }

    private Card[] throwZeroCards() {
        return new Card[0];
    }

    /**
     * Convert a vector containing Card objects to an array.
     * @param cardsToThrow
     * @return
     */
    private Card[] cardVectorToArray(Vector cardsToThrow) {
        Card[] ary = new Card[cardsToThrow.size()];
        for (int i = 0; i < ary.length; i++) {
            ary[i] = (Card)cardsToThrow.elementAt(i);
        }
        return ary;
    }

    private final int LOWEST_RANK = 149747;
    private final int HIGHEST_RANK = 2970356;

    private double getHandStrength() {
        return ((double)HandEvaluator.rankHand(_hand) - (double)LOWEST_RANK + 1.0) /
                ((double)HIGHEST_RANK - (double)LOWEST_RANK);
    }

    private double getPotOdds(int betAmount) {
        return (double)betAmount / ((double)betAmount + (double)_pokerGame.currentRound().getPot());
    }

    private double calcRateOfReturn(int betAmount) {
        double handStrength = (double)getHandStrength();
        double potOdds = (double)getPotOdds(betAmount);
        notifyTextReceivers("HandStrength=" + handStrength + " PotOdds=" + potOdds);
        return handStrength / potOdds;
    }
}
