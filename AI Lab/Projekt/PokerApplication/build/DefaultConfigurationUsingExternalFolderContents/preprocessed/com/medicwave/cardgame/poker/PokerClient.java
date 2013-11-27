/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.*;
import java.util.Random;

/**
 * A class acting as a poker client. It extends the base class {@link PokerClientBase}
 * and is intended to be reviewed and/or changed by students.
 * @author Tobias Persson
 */
public class PokerClient extends PokerClientBase {
    private String name;
    private Random random = new Random();
    private Hand hand;
    
    /**
     * Creates a new instance of <code>PokerClient</code>.
     * @param server    the address of the poker server.
     * @param port      the port used by the poker server.
     */
    public PokerClient(String server, int port) {
        super(server, port);
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
        if( name == null )
            name = "Client#"+(System.currentTimeMillis() & 0xFFF);
        return name;
    }

    /**
     * Called when a new round begins.
     * @param round the round number (increased for each new round).
     */
    protected void infoNewRound(int round) {
        notifyTextReceivers("Starting round #"+round);
    }

    /**
     * Called when the poker server informs that the game is completed.
     */
    protected void infoGameOver() {
        notifyTextReceivers("The game is over.");
    }

    /**
     * Called when the server informs the players how many chips a player has.
     * @param playerName    the name of a player.
     * @param chips         the amount of chips the player has.
     */
    protected void infoPlayerChips(String playerName, int chips) {
        notifyTextReceivers("The player '"+playerName+"' has "+chips+" chips.");
    }
    
    /**
     * Called when the ante has changed.
     * @param ante  the new value of the ante.
     */
    protected void infoAnteChanged(int ante) {
        notifyTextReceivers("The ante is "+ante);
    }

    /**
     * Called when a player had to do a forced bet (putting the ante in the pot).
     * @param playerName    the name of the player forced to do the bet.
     * @param forcedBet     the number of chips forced to bet.
     */
    protected void infoForcedBet(String playerName, int forcedBet) {
        notifyTextReceivers("Player "+playerName +" made a forced bet of "+forcedBet + " chips.");
    }
    
    /**
     * Called when a player opens a betting round.
     * @param playerName        the name of the player that opens.
     * @param openBet           the amount of chips the player has put into the pot.
     */
    protected void infoPlayerOpen(String playerName, int openBet) {
        notifyTextReceivers("Player "+playerName +" opened, has put "+openBet+" chips into the pot.");
    }

    /**
     * Called when a player checks.
     * @param playerName        the name of the player that checks.
     */
    protected void infoPlayerCheck(String playerName) {
        notifyTextReceivers("Player "+playerName +" checked.");
    }

    /**
     * Called when a player raises.
     * @param playerName        the name of the player that raises.
     * @param amountRaisedTo    the amount of chips the player raised to.
     */
    protected void infoPlayerRaise(String playerName, int amountRaisedTo) {
        notifyTextReceivers("Player "+playerName +" raised to "+amountRaisedTo+" chips.");
    }

    /**
     * Called when a player calls.
     * @param playerName        the name of the player that calls.
     */
    protected void infoPlayerCall(String playerName) {
        notifyTextReceivers("Player "+playerName +" called.");
    }

    /**
     * Called when a player folds.
     * @param playerName        the name of the player that folds.
     */
    protected void infoPlayerFold(String playerName) {
        notifyTextReceivers("Player "+playerName +" folded.");
    }

    /**
     * Called when a player goes all-in.
     * @param playerName        the name of the player that goes all-in.
     * @param allInChipCount    the amount of chips the player has in the pot and goes all-in with.
     */
    protected void infoPlayerAllIn(String playerName, int allInChipCount) {
        notifyTextReceivers("Player "+playerName +" goes all-in with a pot of "+allInChipCount+" chips.");
    }

    /**
     * Called when a player has exchanged (thrown away and drawn new) cards.
     * @param playerName        the name of the player that has exchanged cards.
     * @param cardCount         the number of cards exchanged.
     */
    protected void infoPlayerDraw(String playerName, int cardCount) {
        notifyTextReceivers("Player "+playerName +" exchanged "+cardCount+" cards.");
    }

    /**
     * Called during the showdown when a player shows his hand.
     * @param playerName        the name of the player whose hand is shown.
     * @param hand              the players hand.
     */
    protected void infoPlayerHand(String playerName, Hand hand) {
        // The hands toString() methods prepends the returned string with space.
        notifyTextReceivers("Player "+playerName+" has this hand:"+hand+" ("+getHandName(hand)+", category #"+getHandCategory(hand)+")");
    }

    /**
     * Called during the showdown when a players undisputed win is reported.
     * @param playerName    the name of the player whose undisputed win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundUndisputedWin(String playerName, int winAmount) {
        notifyTextReceivers("Player "+playerName+" won "+winAmount+" chips undisputed.");
    }

    /**
     * Called during the showdown when a players win is reported. If a player does not win anything,
     * this method is not called.
     * @param playerName    the name of the player whose win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundResult(String playerName, int winAmount) {
        notifyTextReceivers("Player "+playerName+" won " + winAmount + " chips.");
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
        switch( random.nextInt() % 3 )
        {
            case 0:     return new BettingAnswer(BettingAnswer.ACTION_CHECK);
            case 1:     return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            default:    return new BettingAnswer( playersCurrentBet+playersRemainingChips > minimumPotAfterOpen
                                                    ? BettingAnswer.ACTION_OPEN : BettingAnswer.ACTION_CHECK,
                                                  minimumPotAfterOpen + (playersCurrentBet+playersRemainingChips+10>minimumPotAfterOpen ? random.nextInt(10) : 0 ) );
        }    }

    /**
     * Called when the player receives cards. The hand contains all cards the player currently holds.
     * @param hand  the hand of cards the player currently holds.
     */
    protected void infoCardsInHand(Hand hand) {
        notifyTextReceivers("The cards in hand is" + hand + ".");
        this.hand = hand;
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
    protected BettingAnswer queryCallRaiseAction(int maximumBet, int minimumAmountToRaiseTo, int playersCurrentBet, int playersRemainingChips ) {
        notifyTextReceivers("Player requested to choose a call/raise action.");
        switch( random.nextInt() % 4 )
        {
            case 0:     return new BettingAnswer(BettingAnswer.ACTION_FOLD);
            case 1:     return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            case 2:     return new BettingAnswer( playersCurrentBet+playersRemainingChips>maximumBet
                                                    ? BettingAnswer.ACTION_CALL : BettingAnswer.ACTION_FOLD );
            default:    return new BettingAnswer( playersCurrentBet+playersRemainingChips>minimumAmountToRaiseTo
                                                    ? BettingAnswer.ACTION_RAISE : BettingAnswer.ACTION_FOLD,
                                                  minimumAmountToRaiseTo + (playersCurrentBet+playersRemainingChips+10>minimumAmountToRaiseTo ? random.nextInt(10) : 0 ) );
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
        notifyTextReceivers("Requested information about what cards to throw");
        
        int numberOfCardsToThrow = random.nextInt(5);
        Card[] cards = new Card[numberOfCardsToThrow];
        for( int i = 0; i < cards.length; ++i )
            cards[i] = hand.getCard(i+1); // getCard uses one-based indexing, not zero-based.

        return cards;
    }
}
