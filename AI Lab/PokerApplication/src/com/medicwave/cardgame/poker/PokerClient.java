/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.*;
import java.util.*;

/**
 * A class acting as a poker client. It extends the base class {@link PokerClientBase}
 * and is intended to be reviewed and/or changed by students.
 * @author Tobias Persson
 */
public class PokerClient extends PokerClientBase {

    private String name;
    private Random random = new Random();
    private Hand hand;
    int CurrentRound = 0;
    Hashtable Players;
    int NoOfActions = 0;
    int PlayersFolded = 0;
    private int Ante;
    Vector Raisedplayer = new Vector();
    Vector Checkedplayer = new Vector();
    Player Raised;
    Player Checked;
    Player Me;
    Player Aggresive;
    Player Unaggresive;
    /*
     * rank of highcards           5-12
     * rank of one pair 1-10       371293-371301
     * rank of one pair 10-A       371301-371305
     * rank of two pair            371306-1113878
     * rank of three of a kind     1113879-1113891
     * rank of straight            1485175-1485184
     * rank of flush               1856470-1856477
     * rank of fullhouse           1856478-2599050
     * rank of four of a kind      2599051-2599063
     * straight flush              2970347-2970356
     */
    private final static int VERYGOOD_HAND = 5;
    private final static int GOOD_HAND = 4;
    private final static int MEDIUM_HAND = 3;
    private final static int BAD_HAND = 2;
    private final static int VERYBAD_HAND = 1;

    /**
     * Creates a new instance of <code>PokerClient</code>.
     * @param server    the address of the poker server.
     * @param port      the port used by the poker server.
     */
    public PokerClient(String server, int port) {
        super(server, port);
        Players = new Hashtable();
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
        if (name == null) {
            name = "CH";
        }
        return name;
    }

    /**
     * Called when a new round begins.
     * @param round the round number (increased for each new round).
     */
    protected void infoNewRound(int round) {
        notifyTextReceivers("Starting round #" + round);
        this.CurrentRound = round;
        Checkedplayer.removeAllElements();
        Raisedplayer.removeAllElements();
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
        notifyTextReceivers("The player '" + playerName + "' has " + chips + " chips.");
        String myName = "CH";
        if (this.CurrentRound == 1) {
            /* Create a new object of the player and give him a position */
            Players.put(playerName, new Player(playerName, Players.size()));
        }
        if (Players.get(playerName) != null) {
            if (chips == 0) {
                Players.remove(playerName);
            } else {
                ((Player) Players.get(playerName)).Chips = chips;
                ((Player) (Players.get(playerName))).InRound = true;
            }
        }
        if (playerName.equals(myName)) {
            Me = ((Player) Players.get(playerName));
        }
    }

    /**
     * Called when the ante has changed.
     * @param ante  the new value of the ante.
     */
    protected void infoAnteChanged(int ante) {
        notifyTextReceivers("The ante is " + ante);
        this.Ante = ante;
    }

    /**
     * Called when a player had to do a forced bet (putting the ante in the pot).
     * @param playerName    the name of the player forced to do the bet.
     * @param forcedBet     the number of chips forced to bet.
     */
    protected void infoForcedBet(String playerName, int forcedBet) {
        notifyTextReceivers("Player " + playerName + " made a forced bet of " + forcedBet + " chips.");
    }

    protected boolean raisedplayerIsIncluded(String playerName) {
        Player p;
        if (Raisedplayer.isEmpty() == false) {
            for (int i = 0; i < Raisedplayer.size(); i++) {
                p = (Player) Raisedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    return true;
                }
            }
            return false;
        } else {
            return false;
        }

    }

    protected boolean checkedplayerIsIncluded(String playerName) {
        Player p;
        if (Checkedplayer.isEmpty() == false) {
            for (int i = 0; i < Checkedplayer.size(); i++) {
                p = (Player) Checkedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    return true;
                }
            }
            return false;
        } else {
            return false;
        }
    }

    /**
     * Called when a player opens a betting round.
     * @param playerName        the name of the player that opens.
     * @param openBet           the amount of chips the player has put into the pot.
     */
    protected void infoPlayerOpen(String playerName, int openBet) {
        notifyTextReceivers("Player " + playerName + " opened, has put " + openBet + " chips into the pot.");
        ((Player) Players.get(playerName)).NoOfOpens++;
        ((Player) Players.get(playerName)).LastAction = BettingAnswer.ACTION_OPEN;
        ((Player) Players.get(playerName)).LastRaised = openBet;
        NoOfActions = 1;
        Raised = ((Player) Players.get(playerName));
        boolean temp;
        Player p;
        if (raisedplayerIsIncluded(playerName) == true && (Raised.GetName().equals(Me.GetName())) == false) {
            for (int i = 0; i < Raisedplayer.size(); i++) {
                p = (Player) Raisedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    temp = p.Thrown;
                    Raised.Thrown = temp;
                    Raisedplayer.setElementAt(Raised, i);
                }
            }
        } else if ((raisedplayerIsIncluded(playerName)) == false && (Raised.GetName().equals(Me.GetName())) == false) {
            Raisedplayer.addElement(Raised);
        }
    }

    /**
     * Called when a player checks.
     * @param playerName        the name of the player that checks.
     */
    protected void infoPlayerCheck(String playerName) {
        notifyTextReceivers("Player " + playerName + " checked.");
        ((Player) Players.get(playerName)).NoOfChecks++;
        ((Player) Players.get(playerName)).LastAction = BettingAnswer.ACTION_CHECK;
        NoOfActions++;
        Checked = ((Player) Players.get(playerName));
        boolean temp;
        Player p;
        if (checkedplayerIsIncluded(playerName) && !(Checked.GetName().equals(Me.GetName()))) {
            for (int i = 0; i < Checkedplayer.size(); i++) {
                p = (Player) Checkedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    temp = p.Thrown;
                    Checked.Thrown = temp;
                    Checkedplayer.setElementAt(Checked, i);
                }
            }
        } else if ((!checkedplayerIsIncluded(playerName)) && !(Checked.GetName().equals(Me.GetName()))) {
            Checkedplayer.addElement(Checked);
        }
    }

    /**
     * Called when a player raises.
     * @param playerName        the name of the player that raises.
     * @param amountRaisedTo    the amount of chips the player raised to.
     */
    protected void infoPlayerRaise(String playerName, int amountRaisedTo) {
        notifyTextReceivers("Player " + playerName + " raised to " + amountRaisedTo + " chips.");
        ((Player) Players.get(playerName)).NoOfRaises++;
        ((Player) Players.get(playerName)).LastAction = BettingAnswer.ACTION_RAISE;
        ((Player) Players.get(playerName)).LastRaised = amountRaisedTo;
        NoOfActions = 1;
        Raised = ((Player) Players.get(playerName));
        boolean temp;
        Player p;
        if (raisedplayerIsIncluded(playerName) && !(Raised.GetName().equals(Me.GetName()))) {
            for (int i = 0; i < Raisedplayer.size(); i++) {
                p = (Player) Raisedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    temp = p.Thrown;
                    Raised.Thrown = temp;
                    Raisedplayer.setElementAt(Raised, i);
                }
            }
        } else if ((!raisedplayerIsIncluded(playerName)) && !(Raised.GetName().equals(Me.GetName()))) {
            Raisedplayer.addElement(Raised);
        }
    }

    /**
     * Called when a player calls.
     * @param playerName        the name of the player that calls.
     */
    protected void infoPlayerCall(String playerName) {
        notifyTextReceivers("Player " + playerName + " called.");
        ((Player) Players.get(playerName)).NoOfCalls++;
        ((Player) Players.get(playerName)).LastAction = BettingAnswer.ACTION_CALL;
        NoOfActions++;
        Raised = ((Player) Players.get(playerName));
        boolean temp;
        Player p;
        if (raisedplayerIsIncluded(playerName) && !(Raised.GetName().equals(Me.GetName()))) {
            for (int i = 0; i < Raisedplayer.size(); i++) {
                p = (Player) Raisedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    temp = p.Thrown;
                    Raised.Thrown = temp;
                    Raisedplayer.setElementAt(Raised, i);
                }
            }
        } else if ((!raisedplayerIsIncluded(playerName)) && !(Raised.GetName().equals(Me.GetName()))) {
            Raisedplayer.addElement(Raised);
        }

    }

    /**
     * Called when a player folds.
     * @param playerName        the name of the player that folds.
     */
    protected void infoPlayerFold(String playerName) {
        notifyTextReceivers("Player " + playerName + " folded.");
        ((Player) Players.get(playerName)).NoOfFolds++;
        ((Player) Players.get(playerName)).InRound = false;
        ((Player) Players.get(playerName)).LastAction = BettingAnswer.ACTION_FOLD;
        PlayersFolded++;
        Player p;
        for (int i = 0; i < Raisedplayer.size(); i++) {
            p = (Player) Raisedplayer.elementAt(i);
            if (p.GetName().equals(playerName)) {
                Raisedplayer.removeElementAt(i);
            }
        }
    }

    /**
     * Called when a player goes all-in.
     * @param playerName        the name of the player that goes all-in.
     * @param allInChipCount    the amount of chips the player has in the pot and goes all-in with.
     */
    protected void infoPlayerAllIn(String playerName, int allInChipCount) {
        notifyTextReceivers("Player " + playerName + " goes all-in with a pot of " + allInChipCount + " chips.");
        ((Player) Players.get(playerName)).NoOfAllIns++;
        NoOfActions = 1;
        ((Player) Players.get(playerName)).LastAction = BettingAnswer.ACTION_ALLIN;
        ((Player) Players.get(playerName)).LastRaised = allInChipCount;
        Raised = ((Player) Players.get(playerName));
        boolean temp;
        Player p;
        if (raisedplayerIsIncluded(playerName) == true && (Raised.GetName().equals(Me.GetName())) == false) {
            for (int i = 0; i < Raisedplayer.size(); i++) {
                p = (Player) Raisedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    temp = p.Thrown;
                    Raised.Thrown = temp;
                    Raisedplayer.setElementAt(Raised, i);
                }
            }
        } else if (raisedplayerIsIncluded(playerName) == false && (Raised.GetName().equals(Me.GetName())) == false) {
            Raisedplayer.addElement(Raised);
            notifyTextReceivers("Size is " + Raisedplayer.size() + " xxxxxxxxxx ");
        }
    }

    /**
     * Called when a player has exchanged (thrown away and drawn new) cards.
     * @param playerName        the name of the player that has exchanged cards.
     * @param cardCount         the number of cards exchanged.
     */
    protected void infoPlayerDraw(String playerName, int cardCount) {
        notifyTextReceivers("Player " + playerName + " exchanged " + cardCount + " cards.");
        ((Player) Players.get(playerName)).CardsThrown = cardCount;
        Player p;
        if (Raisedplayer.isEmpty() == false) {
            for (int i = 0; i < Raisedplayer.size(); i++) {
                p = (Player) Raisedplayer.elementAt(i);
                if (p.GetName().equals(playerName)) {
                    p.CardsThrown = cardCount;
                    p.Thrown = true;
                    Raisedplayer.setElementAt(p, i);
                }
            }
        }
    }

    /**
     * Called during the showdown when a player shows his hand.
     * @param playerName        the name of the player whose hand is shown.
     * @param hand              the players hand.
     */
    protected void infoPlayerHand(String playerName, Hand hand) {
        //The hands toString() methods prepends the returned string with space.        
        notifyTextReceivers("Player " + playerName + " has this hand:" + hand + " (" + getHandName(hand) + ", category #" + getHandCategory(hand) + ")");
    }

    /**
     * Called during the showdown when a players undisputed win is reported.
     * @param playerName    the name of the player whose undisputed win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundUndisputedWin(String playerName, int winAmount) {
        notifyTextReceivers("Player " + playerName + " won " + winAmount + " chips undisputed.");
    }

    /**
     * Called during the showdown when a players win is reported. If a player does not win anything,
     * this method is not called.
     * @param playerName    the name of the player whose win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundResult(String playerName, int winAmount) {
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
        return OpenStrtegy(minimumPotAfterOpen, playersCurrentBet, playersRemainingChips);
    }

    /**
     * Called when the player receives cards. The hand contains all cards the player currently holds.
     * @param hand  the hand of cards the player currently holds.
     */
    protected void infoCardsInHand(Hand hand) {
        //notifyTextReceivers("The cards in hand is" + hand + ".");
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
    protected BettingAnswer queryCallRaiseAction(int maximumBet, int minimumAmountToRaiseTo, int playersCurrentBet, int playersRemainingChips) {
        notifyTextReceivers("Player requested to choose a call/raise action.");
        return RaiseStrtegy(maximumBet, minimumAmountToRaiseTo, playersCurrentBet, playersRemainingChips);
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
        return determineCardsToThrow(hand);
    }

    protected Card[] determineCardsToThrow(Hand hand) {
        String handName = HandEvaluator.nameHand(hand);
        if (handName.indexOf("a Pair") != -1) {
            return throwOnePair();
        } else if (handName.indexOf("Two Pair") != -1) {
            return throwTwoPair();
        } else if (handName.indexOf("Three of a Kind") != -1) {
            return throwThreeOfKind();
        } else if (handName.indexOf("High Straight") != -1) {
            return throwZeroCard();
        } else if (handName.indexOf("a Flush") != -1) {
            return throwZeroCard();
        } else if (handName.indexOf("a Full House") != -1) {
            return throwZeroCard();
        } else if (handName.indexOf("Four of a Kind") != -1) {
            return throwFourOfKind();
        } else if (handName.indexOf("High Straight Flush") != -1) {
            return throwZeroCard();
        } else if (handName.indexOf("High") != -1) {
            return ThrowHighCards();
        } else {
            return throwZeroCard();
        }

    }

    private Card[] throwZeroCard() {
        return new Card[0];
    }

    private Card[] throwTwoPair() {
        Card[] cards = new Card[1];
        Card[] tempcard = new Card[5];
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            tempcard[i] = hand.getCard(i + 1);
        }

        cardsort(tempcard);
        if (tempcard[0].getRank() == tempcard[1].getRank() && tempcard[2].getRank() == tempcard[3].getRank()) {
            cards[0] = tempcard[4];
        } else if (tempcard[0].getRank() == tempcard[1].getRank() && tempcard[3].getRank() == tempcard[4].getRank()) {
            cards[0] = tempcard[2];
        } else {
            cards[0] = tempcard[0];
        }

        return cards;
    }

    private Card[] throwFourOfKind() {
        Card[] cards = new Card[1];
        Card[] tempcard = new Card[5];
        int currentcard;
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            tempcard[i] = hand.getCard(i + 1);
        }

        cardsort(tempcard);
        currentcard =
                tempcard[0].getRank();
        if (currentcard == tempcard[1].getRank()) {
            cards[0] = tempcard[4];
        } else if (currentcard != tempcard[1].getRank()) {
            cards[0] = tempcard[0];
        }

        return cards;
    }

    private Card[] ThrowHighCards() {
        Card[] tempcard = new Card[5];
        hand.sort();
        int randomNum;
        randomNum = random.nextInt(100);
        for (int i = 0; i <
                5; i++) {
            tempcard[i] = hand.getCard(i + 1);
        }

        cardsort(tempcard);
        if (fourContinueCards()&&tempcard[0].getRank()<8) {
            return throwFourContinueCards();
        } else if (fourSameSuitCards()) {
            return throwFourSameSuitCards();
        } else if (randomNum >= 50) {
            Card[] cards = new Card[3];
            cards[0] = tempcard[2];
            cards[1] = tempcard[3];
            cards[2] = tempcard[4];
            return cards;
        } else {
            Card[] cards = new Card[4];
            cards[0] = tempcard[3];
            cards[1] = tempcard[4];
            cards[2] = tempcard[1];
            cards[3] = tempcard[2];
            return cards;
        }
    }
    /*boolean the hand whether is four continuous cards*/

    private boolean fourContinueCards() {
        Card[] cards = new Card[5];
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            cards[i] = hand.getCard(i + 1);
        }

        cardsort(cards);
        if (cards[0].getRank() == cards[3].getRank() + 3) {
            return true;
        } else if (cards[1].getRank() == cards[4].getRank() + 3) {
            return true;
        } else if (cards[0].getRank() == cards[4].getRank() + 4) {
            return true;
        } else if (cards[0].getRank() == 12 && cards[4].getRank() == 0 && cards[3].getRank() == 1 && cards[2].getRank() == 2) {
            return true;
        } else if (cards[0].getRank() == 12 && cards[1].getRank() == 3 && cards[3].getRank() == 1 && cards[2].getRank() == 2) {
            return true;
        } else if (cards[0].getRank() == 12 && cards[1].getRank() == 3 && cards[3].getRank() == 1 && cards[4].getRank() == 0) {
            return true;
        } else if (cards[0].getRank() == 12 && cards[1].getRank() == 3 && cards[2].getRank() == 2 && cards[4].getRank() == 0) {
            return true;
        } else {
            return false;
        }
    }

    private Card[] throwFourContinueCards() {
        Card[] cards = new Card[1];
        Card[] tempcard = new Card[5];
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            tempcard[i] = hand.getCard(i + 1);
        }

        cardsort(tempcard);
        if (tempcard[0].getRank() == tempcard[4].getRank() + 4 && tempcard[0].getRank() != tempcard[1].getRank() + 1) {
            cards[0] = tempcard[1];
        } else if (tempcard[0].getRank() == tempcard[4].getRank() + 4 && tempcard[0].getRank() != tempcard[2].getRank() + 2) {
            cards[0] = tempcard[2];
        } else if (tempcard[0].getRank() == tempcard[4].getRank() + 4 && tempcard[0].getRank() != tempcard[3].getRank() + 3) {
            cards[0] = tempcard[3];
        } else if (tempcard[0].getRank() != tempcard[4].getRank() + 4 && tempcard[0].getRank() != tempcard[1].getRank() + 1) {
            cards[0] = tempcard[0];
        } else if (tempcard[0].getRank() != tempcard[4].getRank() + 4 && tempcard[0].getRank() == tempcard[1].getRank() + 1) {
            cards[0] = tempcard[4];
        } else if (tempcard[0].getRank() != tempcard[4].getRank() + 4 && tempcard[0].getRank() == tempcard[1].getRank() + 1) {
            cards[0] = tempcard[4];
        } else if (tempcard[0].getRank() == 12 && tempcard[4].getRank() == 0 && tempcard[3].getRank() == 1 && tempcard[2].getRank() == 2) {
            cards[0] = tempcard[1];
        } else if (tempcard[0].getRank() == 12 && tempcard[1].getRank() == 3 && tempcard[3].getRank() == 1 && tempcard[2].getRank() == 2) {
            cards[0] = tempcard[4];
        } else if (tempcard[0].getRank() == 12 && tempcard[1].getRank() == 3 && tempcard[3].getRank() == 1 && tempcard[4].getRank() == 0) {
            cards[0] = tempcard[2];
        } else {
            cards[0] = tempcard[3];
        }

        return cards;
    }
    /*boolean the hand whether is four same cards*/

    private boolean fourSameSuitCards() {
        Card[] cards = new Card[5];
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            cards[i] = hand.getCard(i + 1);
        }

        cardsort(cards);
        if (cards[0].getSuit() == cards[1].getSuit() && cards[0].getSuit() == cards[2].getSuit() && cards[0].getSuit() == cards[3].getSuit() && cards[0].getSuit() != cards[4].getSuit()) {
            return true;
        } else if (cards[0].getSuit() == cards[1].getSuit() && cards[0].getSuit() == cards[2].getSuit() && cards[0].getSuit() == cards[4].getSuit() && cards[0].getSuit() != cards[3].getSuit()) {
            return true;
        } else if (cards[0].getSuit() == cards[1].getSuit() && cards[0].getSuit() == cards[3].getSuit() && cards[0].getSuit() == cards[4].getSuit() && cards[0].getSuit() != cards[2].getSuit()) {
            return true;
        } else if (cards[1].getSuit() == cards[2].getSuit() && cards[1].getSuit() == cards[3].getSuit() && cards[1].getSuit() == cards[4].getSuit() && cards[0].getSuit() != cards[1].getSuit()) {
            return true;
        } else if (cards[0].getSuit() == cards[2].getSuit() && cards[0].getSuit() == cards[3].getSuit() && cards[0].getSuit() == cards[4].getSuit() && cards[0].getSuit() != cards[1].getSuit()) {
            return true;
        } else {
            return false;
        }

    }

    private Card[] throwFourSameSuitCards() {
        Card[] cards = new Card[1];
        Card[] tempcard = new Card[5];
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            tempcard[i] = hand.getCard(i + 1);
        }

        cardsort(tempcard);
        if (tempcard[0].getSuit() == tempcard[1].getSuit() && tempcard[0].getSuit() == tempcard[2].getSuit() && tempcard[0].getSuit() == tempcard[3].getSuit()) {
            cards[0] = tempcard[4];
        } else if (tempcard[0].getSuit() == tempcard[1].getSuit() && tempcard[0].getSuit() == tempcard[2].getSuit() && tempcard[0].getSuit() == tempcard[4].getSuit()) {
            cards[0] = tempcard[3];
        } else if (tempcard[0].getSuit() == tempcard[1].getSuit() && tempcard[0].getSuit() == tempcard[3].getSuit() && tempcard[0].getSuit() == tempcard[4].getSuit()) {
            cards[0] = tempcard[2];
        } else if (tempcard[1].getSuit() == tempcard[2].getSuit() && tempcard[1].getSuit() == tempcard[3].getSuit() && tempcard[1].getSuit() == tempcard[4].getSuit()) {
            cards[0] = tempcard[0];
        } else {
            cards[0] = tempcard[1];
        }

        return cards;
    }

    private Card[] throwOnePair() {
        Card[] tempcard = new Card[5];
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            tempcard[i] = hand.getCard(i + 1);
        }

        cardsort(tempcard);
        if (tempcard[0].getRank() == tempcard[1].getRank()) {
            if (Players.size() == 5) {
                if (fourContinueCards() && tempcard[0].getRank() < 6) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 7) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[2];
                    return cards;
                }

            } else if (Players.size() == 4) {
                if (fourContinueCards() && tempcard[0].getRank() < 5) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 6) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[2];
                    return cards;
                }

            } else if (Players.size() == 3) {
                if (fourContinueCards() && tempcard[0].getRank() < 4) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 5) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[2];
                    return cards;
                }

            } else {
                if (fourSameSuitCards() && tempcard[0].getRank() < 4) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[2];
                    return cards;
                }

            }
        } else if (tempcard[1].getRank() == tempcard[2].getRank()) {
            if (Players.size() == 5) {
                if (fourContinueCards() && tempcard[0].getRank() < 6) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 7) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            } else if (Players.size() == 4) {
                if (fourContinueCards() && tempcard[0].getRank() < 5) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 6) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            } else if (Players.size() == 3) {
                if (fourContinueCards() && tempcard[0].getRank() < 4) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 5) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            } else {
                if (fourSameSuitCards() && tempcard[0].getRank() < 4) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[3];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            }
        } else if (tempcard[2].getRank() == tempcard[3].getRank()) {
            if (Players.size() == 5) {
                if (fourContinueCards() && tempcard[0].getRank() < 6) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 7) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            } else if (Players.size() == 4) {
                if (fourContinueCards() && tempcard[0].getRank() < 5) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 6) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            } else if (Players.size() == 3) {
                if (fourContinueCards() && tempcard[0].getRank() < 4) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 5) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            } else {
                if (fourSameSuitCards() && tempcard[0].getRank() < 4) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[4];
                    cards[2] = tempcard[0];
                    return cards;
                }

            }
        } else {
            if (Players.size() == 5) {
                if (fourContinueCards() && tempcard[0].getRank() < 6) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 7) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[2];
                    cards[2] = tempcard[3];
                    return cards;
                }

            } else if (Players.size() == 4) {
                if (fourContinueCards() && tempcard[0].getRank() < 5) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 6) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[2];
                    cards[2] = tempcard[3];
                    return cards;
                }

            } else if (Players.size() == 3) {
                if (fourContinueCards() && tempcard[0].getRank() < 4) {
                    return throwFourContinueCards();
                } else if (fourSameSuitCards() && tempcard[0].getRank() < 5) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[2];
                    cards[2] = tempcard[3];
                    return cards;
                }

            } else {
                if (fourSameSuitCards() && tempcard[0].getRank() < 4) {
                    return throwFourSameSuitCards();
                } else {
                    Card[] cards = new Card[3];
                    cards[0] = tempcard[1];
                    cards[1] = tempcard[2];
                    cards[2] = tempcard[3];
                    return cards;
                }

            }
        }
    }

    private Card[] throwThreeOfKind() {
        Card[] cards = new Card[2];
        Card[] tempcard = new Card[5];
        hand.sort();
        for (int i = 0; i <
                5; i++) {
            tempcard[i] = hand.getCard(i + 1);
        }

        cardsort(tempcard);
        if (tempcard[0].getRank() == tempcard[1].getRank() && tempcard[0].getRank() == tempcard[2].getRank()) {
            cards[0] = tempcard[3];
            cards[1] = tempcard[4];
        } else if (tempcard[1].getRank() == tempcard[2].getRank() && tempcard[1].getRank() == tempcard[3].getRank()) {
            cards[0] = tempcard[0];
            cards[1] = tempcard[4];
        } else if (tempcard[2].getRank() == tempcard[3].getRank() && tempcard[2].getRank() == tempcard[4].getRank()) {
            cards[0] = tempcard[0];
            cards[1] = tempcard[1];
        }

        return cards;
    }

    protected void cardsort(Card[] card) {
        Card[] temp = new Card[1];
        for (int i = 0; i <
                5; i++) {
            for (int j = i; j <
                    5; j++) {
                if (card[i].getRank() < card[j].getRank()) {
                    temp[0] = card[j];
                    card[j] = card[i];
                    card[i] = temp[0];
                }

            }
        }
    }

    protected int HandEvaluate() {
        int handrank = 0;
        int handlevel = 0;
        hand.sort();
        handrank =
                HandEvaluator.rankHand(hand);
        if (handrank >= 149747 && handrank < 379854) {
            handlevel = VERYBAD_HAND;
        } else if (handrank >= 379854 && handrank < 393470) {
            handlevel = BAD_HAND;
        } else if (handrank >= 393470 && handrank < 398008) {
            handlevel = MEDIUM_HAND;
        } else if (handrank >= 398008 && handrank < 2208336) {
            handlevel = GOOD_HAND;
        } else {
            handlevel = VERYGOOD_HAND;
        }

        return handlevel;
    }

    protected BettingAnswer OpenStrtegy(int minimumPotAfterOpen, int playersCurrentBet, int playersRemainingChips) {
        /*if there's nobody open, I will control the game*/
        if (Raisedplayer.size() == 0) //nobody opened
        {
            if (playersRemainingChips >= (800 - 60 * Players.size()) && HandEvaluate() >= 2) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else if (HandEvaluate() <= 2 && playersCurrentBet + playersRemainingChips > minimumPotAfterOpen) {
                return new BettingAnswer(BettingAnswer.ACTION_OPEN, minimumPotAfterOpen);
            } else if (HandEvaluate() <= 2 && playersCurrentBet + playersRemainingChips <= minimumPotAfterOpen) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else if (HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips > minimumPotAfterOpen + (int) (0.05 * playersRemainingChips)) {
                return new BettingAnswer(BettingAnswer.ACTION_OPEN, minimumPotAfterOpen + (int) (0.05 * playersRemainingChips));
            } else if (HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips > minimumPotAfterOpen) {
                return new BettingAnswer(BettingAnswer.ACTION_OPEN, minimumPotAfterOpen);
            } else if (HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips <= minimumPotAfterOpen) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else if (HandEvaluate() == 4 && playersCurrentBet + playersRemainingChips > minimumPotAfterOpen + (int) (0.25 * playersRemainingChips)) {
                return new BettingAnswer(BettingAnswer.ACTION_OPEN, minimumPotAfterOpen + (int) (0.25 * playersRemainingChips));
            } else if (HandEvaluate() == 4 && playersCurrentBet + playersRemainingChips <= minimumPotAfterOpen + (int) (0.25 * playersRemainingChips)) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else if (HandEvaluate() == 5 && playersCurrentBet + playersRemainingChips > minimumPotAfterOpen + (int) (0.4 * playersRemainingChips)) {
                return new BettingAnswer(BettingAnswer.ACTION_OPEN, minimumPotAfterOpen + (int) (0.4 * playersRemainingChips));
            } else {                        // if (HandEvaluate() == 5 and there's no enough money to open

                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            }

        } else /*this open is after players thrown the cards, so we should be more careful, analysis the cards thay thrown first*/ {
            Player p;
            Player BestHand;

            BestHand =
                    (Player) Raisedplayer.firstElement();
            int bestHandNow = BestHand.CardsThrown;
            for (int i = 0; i <
                    Raisedplayer.size(); i++) {
                p = (Player) Raisedplayer.elementAt(i);
                if (p.CardsThrown < bestHandNow) {
                    bestHandNow = p.CardsThrown;
                }

            }
            if (bestHandNow == 0 && HandEvaluator.rankHand(hand) < 1485175) {
                return new BettingAnswer(BettingAnswer.ACTION_CHECK);
            } else if (bestHandNow == 1 && HandEvaluator.rankHand(hand) < 400000) {
                return new BettingAnswer(BettingAnswer.ACTION_CHECK);
            } else if (bestHandNow == 2 && HandEvaluator.rankHand(hand) < 380000) {
                return new BettingAnswer(BettingAnswer.ACTION_CHECK);
            } else if (playersRemainingChips >= (800 - 60 * Players.size()) && HandEvaluate() >= 2) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else if (playersCurrentBet + playersRemainingChips > minimumPotAfterOpen) {
                return new BettingAnswer(BettingAnswer.ACTION_OPEN, minimumPotAfterOpen);
            } else {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            }

        }
    }

    protected BettingAnswer RaiseStrtegy(int maximumBet, int minimumAmountToRaiseTo, int playersCurrentBet, int playersRemainingChips) {
        int randomNumber;
        Player p = (Player) Raisedplayer.firstElement();
        if (p.Thrown == false) {
            if (playersRemainingChips >= (800 - 60 * Players.size()) && HandEvaluate() >= 2) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else {
                /*the strategy for someone very aggresive or very unaggresive*/
                /*1*/ if (someOneVeryUnAgg() && Unaggresive.LastAction == BettingAnswer.ACTION_ALLIN && HandEvaluator.rankHand(hand) < 398008) {
                    return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                /*2*/ } else if (someOneVeryUnAgg() && Unaggresive.LastAction == BettingAnswer.ACTION_RAISE && Unaggresive.LastRaised > ((int) (0.7 * Unaggresive.Chips) + this.Ante) && HandEvaluator.rankHand(hand) < 398008) {
                    return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                /*3*/ } else if (someOneVeryUnAgg() && Unaggresive.LastAction == BettingAnswer.ACTION_OPEN && Unaggresive.LastRaised > ((int) (0.4 * Unaggresive.Chips) + this.Ante) && HandEvaluator.rankHand(hand) < 398008) {
                    return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                /*4*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_ALLIN && Aggresive.LastRaised < ((int) (0.3 * playersRemainingChips)) && HandEvaluate() == 2) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*5*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_ALLIN && Aggresive.LastRaised < ((int) (0.5 * playersRemainingChips)) && HandEvaluate() == 3) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*6*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_ALLIN && HandEvaluate() > 3) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*7*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*8*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*9*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.5 * Aggresive.Chips)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*10*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.5 * Aggresive.Chips)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*11*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*12*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*13*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.1 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*14*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.1 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*15*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*16*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*17*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                    return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                /*18*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips <= minimumAmountToRaiseTo) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                } else {
                    /*the normal strategy*/
                    if (HandEvaluate() == 1) {
                        randomNumber = random.nextInt(100);
                        if ((randomNumber <= 30 || minimumAmountToRaiseTo > ((int) (0.2 * playersRemainingChips)) || HandEvaluator.rankHand(hand) < 264800 || playersCurrentBet + playersRemainingChips <= maximumBet)&&Players.size()<4) {
                            return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                        } else if (randomNumber <= 50 || minimumAmountToRaiseTo > ((int) (0.2 * playersRemainingChips)) || HandEvaluator.rankHand(hand) < 264800 || playersCurrentBet + playersRemainingChips <= maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                        }else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else if (HandEvaluate() == 2) {
                        randomNumber = random.nextInt(100);
                        if (randomNumber <= 80 && playersCurrentBet < (2 * this.Ante + (int) (0.2 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        } else if (randomNumber > 80 && playersCurrentBet < (2 * this.Ante + (int) ((0.2 * playersRemainingChips))) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + 25 - 5 * Players.size() + (int) (0.05 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + 25 - 5 * Players.size() + (int) (0.05 * playersRemainingChips));
                        } else if (playersCurrentBet > (int) (0.5 * Me.Chips) || playersCurrentBet > 20 * this.Ante) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (playersCurrentBet >= (2 * this.Ante + (int) (0.2 * playersRemainingChips)) || playersCurrentBet + playersRemainingChips <= maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else if (HandEvaluate() == 3) {
                        randomNumber = random.nextInt(100);
                        if (randomNumber > 85) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (randomNumber <= 85 && playersCurrentBet < (3 * this.Ante + (int) (0.3 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.2 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + 20);
                        } else if (randomNumber <= 85 && playersCurrentBet < (3 * this.Ante + (int) (0.3 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.1 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + 10);
                        } else if (randomNumber <= 85 && playersCurrentBet < (3 * this.Ante + (int) (0.3 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                        } else if (playersCurrentBet > (int) (0.3 * Me.Chips) || playersCurrentBet > 15 * this.Ante) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (playersCurrentBet + playersRemainingChips <= maximumBet || playersCurrentBet >= (3 * this.Ante + (int) (0.3 * playersRemainingChips))) {
                            return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else if (HandEvaluate() == 4) {
                        randomNumber = random.nextInt(100);
                        if (randomNumber > 70 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.5 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.5 * playersRemainingChips));
                        } else if (randomNumber > 70) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (randomNumber >= 35 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.25 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.25 * playersRemainingChips));
                        } else if (randomNumber >= 35 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                        } else if (playersCurrentBet + playersRemainingChips <= maximumBet || randomNumber < 35) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else {
                        randomNumber = random.nextInt(100);
                        if (randomNumber > 50 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.6 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.6 * playersRemainingChips));
                        } else if (randomNumber > 50) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.3 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.3 * playersRemainingChips));
                        } else if (playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                        } else if (playersCurrentBet + playersRemainingChips <= maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    }
                }
            }
        } else {
            /*the players have thrown the cards, so we should be more careful*/
            Player q;
            Player BestHand;

            BestHand =
                    (Player) Raisedplayer.elementAt(0);
            int bestHandNow = BestHand.CardsThrown;
            for (int i = 0; i <
                    Raisedplayer.size(); i++) {
                q = (Player) Raisedplayer.elementAt(i);
                if (q.CardsThrown < bestHandNow) {
                    bestHandNow = q.CardsThrown;
                }

            }
            if (bestHandNow == 0 && HandEvaluator.rankHand(hand) < 379854) {
                return new BettingAnswer(BettingAnswer.ACTION_FOLD);
            } else if (bestHandNow == 1 && HandEvaluator.rankHand(hand) < 399521) {
                return new BettingAnswer(BettingAnswer.ACTION_FOLD);
            } else if (bestHandNow == 2 && HandEvaluator.rankHand(hand) < 379854) {
                return new BettingAnswer(BettingAnswer.ACTION_FOLD);
            } else if (bestHandNow >= 3 && HandEvaluator.rankHand(hand) >= 450000 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.3 * playersRemainingChips)) {
                return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.3 * playersRemainingChips));
            } else if (bestHandNow >= 3 && HandEvaluator.rankHand(hand) >= 450000 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
            } else if (bestHandNow >= 3 && HandEvaluator.rankHand(hand) >= 450000 && playersCurrentBet + playersRemainingChips <= minimumAmountToRaiseTo) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else if (playersRemainingChips >= (800 - 60 * Players.size()) && HandEvaluate() >= 2) {
                return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            } else {
                /*the strategy for someone very aggresive or very unaggresive*/
                /*1*/ if (someOneVeryUnAgg() && Unaggresive.LastAction == BettingAnswer.ACTION_ALLIN && HandEvaluator.rankHand(hand) < 398008) {
                    return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                /*2*/ } else if (someOneVeryUnAgg() && Unaggresive.LastAction == BettingAnswer.ACTION_RAISE && Unaggresive.LastRaised > ((int) (0.7 * Unaggresive.Chips) + this.Ante) && HandEvaluator.rankHand(hand) < 398008) {
                    return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                /*3*/ } else if (someOneVeryUnAgg() && Unaggresive.LastAction == BettingAnswer.ACTION_OPEN && Unaggresive.LastRaised > ((int) (0.4 * Unaggresive.Chips) + this.Ante) && HandEvaluator.rankHand(hand) < 398008) {
                    return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                /*4*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_ALLIN && Aggresive.LastRaised < ((int) (0.3 * playersRemainingChips)) && HandEvaluate() == 2) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*5*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_ALLIN && Aggresive.LastRaised < ((int) (0.5 * playersRemainingChips)) && HandEvaluate() == 3) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*6*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_ALLIN && HandEvaluate() > 3) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*7*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*8*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*9*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.5 * Aggresive.Chips)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*10*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && Aggresive.LastRaised < ((int) (0.5 * Aggresive.Chips)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*11*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*12*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_RAISE && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*13*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.1 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*14*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.1 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 2 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*15*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips > maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_CALL);
                /*16*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && Aggresive.LastRaised < ((int) (0.3 * Aggresive.Chips + this.Ante)) && HandEvaluate() == 3 && playersCurrentBet + playersRemainingChips <= maximumBet) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                /*17*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                    return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                /*18*/ } else if (someOneVeryAgg() && Aggresive.LastAction == BettingAnswer.ACTION_OPEN && HandEvaluate() > 3 && playersCurrentBet + playersRemainingChips <= minimumAmountToRaiseTo) {
                    return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                } else {
                    /*the normal strategy*/
                    if (HandEvaluate() == 1) {
                        randomNumber = random.nextInt(100);
                        if (randomNumber <= 30 || minimumAmountToRaiseTo > ((int) (0.2 * playersRemainingChips)) || HandEvaluator.rankHand(hand) < 264800 || playersCurrentBet + playersRemainingChips <= maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else if (HandEvaluate() == 2) {
                        randomNumber = random.nextInt(100);
                        if (randomNumber <= 80 && playersCurrentBet < (2 * this.Ante + (int) (0.2 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        } else if (randomNumber > 80 && playersCurrentBet < (2 * this.Ante + (int) ((0.2 * playersRemainingChips))) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + 25 - 5 * Players.size() + (int) (0.05 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + 25 - 5 * Players.size() + (int) (0.05 * playersRemainingChips));
                        } else if (playersCurrentBet > (int) (0.5 * Me.Chips) || playersCurrentBet > 20 * this.Ante) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (playersCurrentBet >= (2 * this.Ante + (int) (0.2 * playersRemainingChips)) || playersCurrentBet + playersRemainingChips <= maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else if (HandEvaluate() == 3) {
                        randomNumber = random.nextInt(100);
                        if (randomNumber > 85) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (randomNumber <= 85 && playersCurrentBet < (3 * this.Ante + (int) (0.3 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.2 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + 20);
                        } else if (randomNumber <= 85 && playersCurrentBet < (3 * this.Ante + (int) (0.3 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.1 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + 10);
                        } else if (randomNumber <= 85 && playersCurrentBet < (3 * this.Ante + (int) (0.3 * playersRemainingChips)) && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                        } else if (playersCurrentBet > (int) (0.3 * Me.Chips) || playersCurrentBet > 15 * this.Ante) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (playersCurrentBet + playersRemainingChips <= maximumBet || playersCurrentBet >= (3 * this.Ante + (int) (0.3 * playersRemainingChips))) {
                            return new BettingAnswer(BettingAnswer.ACTION_FOLD);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else if (HandEvaluate() == 4) {
                        randomNumber = random.nextInt(100);
                        if (randomNumber > 70 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.5 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.5 * playersRemainingChips));
                        } else if (randomNumber > 70) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (randomNumber >= 35 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.25 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.25 * playersRemainingChips));
                        } else if (randomNumber >= 35 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                        } else if (playersCurrentBet + playersRemainingChips <= maximumBet || randomNumber < 35) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    } else {
                        randomNumber = random.nextInt(100);
                        if (randomNumber > 50 && playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.6 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.6 * playersRemainingChips));
                        } else if (randomNumber > 50) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else if (playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo + (int) (0.3 * playersRemainingChips)) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo + (int) (0.3 * playersRemainingChips));
                        } else if (playersCurrentBet + playersRemainingChips > minimumAmountToRaiseTo) {
                            return new BettingAnswer(BettingAnswer.ACTION_RAISE, minimumAmountToRaiseTo);
                        } else if (playersCurrentBet + playersRemainingChips <= maximumBet) {
                            return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
                        } else {
                            return new BettingAnswer(BettingAnswer.ACTION_CALL);
                        }

                    }
                }
            }
        }
    }

    protected boolean someOneVeryAgg() {
        Player p;
        for (int i = 0; i <
                Raisedplayer.size(); i++) {
            p = (Player) Raisedplayer.elementAt(i);
            if (p.Aggresitivity > 0.75) {
                Aggresive = p;
                return true;
            }

        }
        return false;
    }

    protected boolean someOneVeryUnAgg() {
        Player p;
        for (int i = 0; i <
                Raisedplayer.size(); i++) {
            p = (Player) Raisedplayer.elementAt(i);
            if (p.Aggresitivity < 0.25) {
                Unaggresive = p;
                return true;
            }

        }
        return false;
    }
}  